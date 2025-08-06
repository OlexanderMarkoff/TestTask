//
//  ExisitngUsersViewModel.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

final class ExisitngUsersViewModel: FormViewModel {

    private var state: State

    private lazy var noUsersField: AppMessageField = {
        return AppMessageField(tag: -1, model: .noUsers, buttonuttonTapped: {})

    }()

    private lazy var loaderField =  LoaderField()

    override init() {
        self.state = State()
        super.init()
        sections = [makeNoUsersSection()]
    }

    override func subscribe(with updateCallback: ViewModelCallback?) {
        super.subscribe(with: updateCallback)
        reloadUsers()

    }

    func reloadUsers() {
        state.loadedPages = [:]
        fetchUsers()
    }

    private func fetchUsers(page: Int = 1, count: Int = 6) {
        if let request = TestTaskRequest.makeGetUsersRequest(page: page, count: count).plainRequest {
            state.loadedPages[page - 1] = nil
            if page == 1 {displayLoadingView()}
            _ = Task { [weak self] in
                do {
                    let usersPage: UsersPage = try await fetch(request: request)

                    await MainActor.run { [weak self] in
                        if !usersPage.users.isEmpty {
                            self?.pageLoaded(usersPage: usersPage)
                        }
                        self?.hideLoadingView()}
                } catch let error {
                    self?.updateCallback?(error.localizedDescription)
                    await MainActor.run { [weak self] in self?.hideLoadingView()}
                }
            }
        } else {
            updateCallback?("error.request.get_users_fails".localized)
        }
    }

    private func pageLoaded(usersPage: UsersPage) {
        state.loadedPages[usersPage.page - 1] = usersPage

        let sectionIndex = usersPage.page - 1
        let cells = usersPage.users.enumerated().map { (index, userResponse)  in
            return UserField(tag: index, model: UserFieldModel.init(userResponse: userResponse))
        }
        sections[sectionIndex] = FormSection(id: sectionIndex, cells: cells)
        redrawSection(sectionIndex)

        if usersPage.links.nextUrl != nil { // if no next -- no need to show a loader
            sections.append(FormSection(id: sectionIndex + 1, cells: [loaderField]))
            notifySectionAdded(sectionIndex + 1)
            redrawSection(sectionIndex + 1)
        }
    }

    func sectionFullyShown(section: Int) {
        if !state.loadedPages.keys.contains(section) {// if key exists -- loanig next page requested
            guard let page = state.loadedPages[section - 1] else { return }// get previous page to check if next exists
            if page?.links.nextUrl  == nil { return } // nil means no next page
            fetchUsers(page: (page?.page ?? 0) + 1)
        }
    }

    private func makeNoUsersSection() -> FormSection {
        return FormSection(id: 0, cells: [noUsersField])
    }

    func onRowSelected(indexPath: IndexPath) {
        guard sections[indexPath.section].cells[indexPath.row] is UserField else { return }
        if let user = state.loadedPages[indexPath.section]??.users[indexPath.row] {
            print(user.name)
        }
    }

    struct State {
        var loadedPages: [Int: UsersPage?] = [:]
    }

}
