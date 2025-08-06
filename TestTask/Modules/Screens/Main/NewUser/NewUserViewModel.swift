//
//  NewUserViewModel.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import Foundation

final class NewUserViewModel: FormViewModel {

    var requestPhotoPicker: (_ photoSelectionCallback: @escaping (URL) -> Void) -> Void = { _ in }
    var showErrorScreen: (_ message: String) -> Void = { _ in }
    var showSucessScreen: () -> Void = {}

    private var state: State

    lazy var userNameField: InputField = {
        let model = InputFormFieldModel(placeholder: "common.your_name".localized,
                                        rules: [StringValidationRules.lengthBetween(2...60)],
                                        state: InputState(value: ""))

        return InputField(tag: Tags.Cells.username, model: model, textInputCallback: { [weak self] in
            self?.textDidEdit(text: $0, tag: Tags.Cells.username)
        })
    }()

    lazy var userEmailField: InputField = {
        let model = InputFormFieldModel(placeholder: "common.email".localized,
                                        rules: [StringValidationRules.isValidEmailAddress],
                                        state: InputState(value: ""))

        return InputField(tag: Tags.Cells.email, model: model, textInputCallback: { [weak self] in
            self?.textDidEdit(text: $0, tag: Tags.Cells.email)
        })
    }()

    lazy var userPhoneField: InputField = {
        let model = InputFormFieldModel(placeholder: "common.phone".localized,
                                        messageOfEmptyField: "+38 (XXX) XXX - XX - XX",
                                        keyboardType: .numberPad,
                                        rules: [StringValidationRules.isValidPhoneNumber],
                                        state: InputState(value: "+380"))

        return InputField(tag: Tags.Cells.phone, model: model, textInputCallback: { [weak self] in
            self?.textDidEdit(text: $0, tag: Tags.Cells.phone)
        })
    }()

    lazy var uploadPhotoField: LabelWithActionField = {
        let model = LabelWithActionFieldModel(title: "upload_photo".localized, action: "common.upload".localized)

        return LabelWithActionField(tag: Tags.Cells.photo, model: model, actionDidTap: { [weak self] in
            self?.uploadActionTapped()
        })
    }()

    override init() {
        self.state = State()
        super.init()
        var sections: [FormSection] = []
        sections.append(FormSection(id: Tags.Sections.userDatails, cells: [Spacer(height: 32), userNameField,
                                                                           Spacer(height: 12), userEmailField,
                                                                           Spacer(height: 12), userPhoneField]))

        sections.append(FormSection(id: Tags.Sections.userPosition,
                                    title: "tile.select_position".localized,
                                    cells: [LoaderField()]))

        sections.append(FormSection(id: Tags.Sections.userPhoto,
                                    cells: [Spacer(height: 8), uploadPhotoField]))
        self.sections = sections
    }

    override func subscribe(with updateCallback: ViewModelCallback?) {
        super.subscribe(with: updateCallback)
        fetchPositions()
    }

    private func fetchPositions() {
        if let request = TestTaskRequest.makeGetPositionsReuest().plainRequest {
            _ = Task { [weak self] in
                do {
                    let positions: PositionsResponse = try await fetch(request: request)

                    await MainActor.run { [weak self] in
                        if !positions.positions.isEmpty {
                            self?.positionsLoaded(postions: positions)
                        }
                    }
                } catch let error {
                    self?.updateCallback?(error.localizedDescription)
                }
            }
        } else {
            updateCallback?("error.request.get_users_fails".localized)
        }
    }

    private func positionsLoaded(postions: PositionsResponse) {
//        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
//            guard let self = self else { return }
            state.selectedPositionIndex = 0
            state.userPositions = postions.positions

            var postionCells: [FormField] = []
            postionCells.append(Spacer(height: 12))

            postionCells.append(contentsOf: postions.positions.enumerated().map { (index, positionResponse) in
                return CheckboxField(tag: index, model: CheckboxFieldModel(isSelected: index == 0, title: positionResponse.name))
            })

            sections[Tags.Sections.userPosition].cells = postionCells
            redrawSection(Tags.Sections.userPosition)
//        }
    }

    // timer just to make some delay before main screen shown
    var timer: Timer?
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func onRowSelected(indexPath: IndexPath) {
        guard sections[indexPath.section].id  == Tags.Sections.userPosition else { return }
        for field in sections[indexPath.section].cells {
            let neededRow = indexPath.row - 1 // -1 because first section is spacer
            if field.tag == neededRow {
                self.state.selectedPositionIndex = neededRow
            }
            (field as? CheckboxField)?.model.isSelected = field.tag == neededRow
        }
    }

    override func submit() {
        displayLoadingView()
        if let request = TestTaskRequest.getTokenRequest().plainRequest {
            _ = Task { [weak self] in
                do {
                    let tokenResponse: GetTokenResponse = try await fetch(request: request)

                    await MainActor.run { [weak self] in
                        if tokenResponse.success {
                            self?.registerNewUser(token: tokenResponse.token)
                        } else {
                            self?.updateCallback?("error.get_token_fails".localized)
                            self?.hideLoadingView()
                        }
                    }
                } catch let error {
                    await MainActor.run { [weak self] in
                        self?.updateCallback?(error.localizedDescription)
                        self?.hideLoadingView()
                    }
                }
            }
        } else {
            updateCallback?("error.get_token_wrong".localized)
            hideLoadingView()
        }
    }

    private func textDidEdit(text: String, tag: Int) {
        for section in self.sections where section.id == Tags.Sections.userDatails {
            switch tag {
            case Tags.Cells.username:
                state.username = text
            case Tags.Cells.email:
                state.email = text
            case Tags.Cells.phone:
                state.phone = text
            default: break // do nothing
            }
        }
        validateFields()
    }

    private func uploadActionTapped() {
        requestPhotoPicker(funcPhotoLoaded)
    }

    private func funcPhotoLoaded(photoUrl: URL) {
        state.selectedPhotoUrl = photoUrl
        uploadPhotoField.model.title = photoUrl.lastPathComponent
        validateFields()
    }

    private func validateFields() {
        var isValid = true
        isValid = userNameField.validate() && isValid
        isValid = userEmailField.validate() && isValid
        isValid = userPhoneField.validate() && isValid

        isValid = (state.selectedPositionIndex >= 0) && isValid

        isValid = (state.selectedPhotoUrl != nil) && isValid

        actionButtonAccessibility(isValid)
    }

    private func registerNewUser(token: String) {

        do {
            if let fileUrl = state.selectedPhotoUrl {

                let bodyParams: [String: String] = [
                    "name": state.username,
                    "email": state.email,
                    "phone": state.phone,
                    "position_id": "\(state.userPositions[state.selectedPositionIndex].id)"
                ]
                let data = try Data(contentsOf: fileUrl)
                let binaryParams: [String: Data] = [ "photo": data]

        if let request = TestTaskRequest.createNewUser(bodyParams: bodyParams, binaryParams: binaryParams, token: token).multipartRequest {
            _ = Task { [weak self] in
                do {
                    let newUserResponse: NewUserResponse = try await fetch(request: request)

                    await MainActor.run { [weak self] in
                        if newUserResponse.success {
                            self?.showSucessScreen()
                        } else if let error = newUserResponse.fails {
                            self?.handleCreatreUserErrors(error: error)
                        } else {
                            self?.showErrorScreen(newUserResponse.message)
                        }
                        self?.hideLoadingView()
                    }
                } catch let error {
                    await MainActor.run { [weak self] in
                        self?.updateCallback?(error.localizedDescription)
                        self?.hideLoadingView()
                    }
                }
            }
        } else {
            updateCallback?("error.new_user_wrong".localized)
            hideLoadingView()
        }
            }

        } catch {
            updateCallback?("File mapping failed")
            return
        }
    }

    private func handleCreatreUserErrors(error: NewUserFailsResponse) {
        showErrorScreen(error.getErrors())
    }

    private struct State {
        var username = ""
        var email = ""
        var phone = ""
        var userPositions: [PositionResponse] = []
        var selectedPositionIndex = -1
        var selectedPhotoUrl: URL?
    }

    private enum Tags {
        enum Sections {
            static let userDatails = 0
            static let userPosition = 1
            static let userPhoto = 2
        }

        enum Cells {
            static let username = 0
            static let email = 1
            static let phone = 2
            static let photo = 3
        }
    }
}
