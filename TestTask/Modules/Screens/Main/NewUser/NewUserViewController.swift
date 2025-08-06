//
//  NewUserViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

final class NewUserViewController: FormViewController {

    override var hasActionButton: Bool {true}
    var photoDidSelectk: ((URL) -> Void)?

    init() {
        super.init(nibName: nil, bundle: nil)

        let tabBarImage = Asset.bottombarSignUp.image.draw(text: "common.signup".localized)
        tabBarItem = UITabBarItem(
            title: "",
            image: tabBarImage,
            selectedImage: tabBarImage
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        parent?.navigationItem.title = "screen.signup.title".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        actionToolbar.actionButton.isEnabled = false
        actionToolbar.actionButton.setTitle("common.signup".localized, for: .normal)
    }

    func presentPickPhotoSheet(photoSelectionCallback: @escaping (URL) -> Void) {

        let actionSheet = UIAlertController(title: nil, message: "message.choose_photo".localized, preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "common.camera".localized, style: .default) { _ in
            self.showImagePicker(
                selectionCallBack: photoSelectionCallback,
                useCamera: true
            )
        }

        let galeryAction = UIAlertAction(title: "common.gallery".localized, style: .default) { _ in
            self.showImagePicker(
                selectionCallBack: photoSelectionCallback,
                useCamera: false
            )
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "common.cancel".localized, style: .cancel) { _ in }

        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galeryAction)
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true)
    }
}

extension NewUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func showImagePicker(
        selectionCallBack: @escaping (URL) -> Void,
        useCamera: Bool
    ) {
        photoDidSelectk = selectionCallBack
        let uiPicker = UIImagePickerController()
        uiPicker.delegate = self
        uiPicker.allowsEditing = false

        if UIImagePickerController.isSourceTypeAvailable(.camera) && useCamera {
            uiPicker.sourceType = UIImagePickerController.SourceType.camera
            uiPicker.cameraDevice = UIImagePickerController.CameraDevice.rear
            self.navigationController?.present(uiPicker, animated: true, completion: { })
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            uiPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.navigationController?.present(uiPicker, animated: true, completion: { })
        }
    }

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

         guard let image = info[.originalImage] as? UIImage,
               let imageURLPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
             AppMessage.shared.display("Document uploading failed")// today I'm to lazzy to put in inlo localization
             picker.dismiss(animated: true, completion: nil) // close window if uploadind/mapping fails
             photoDidSelectk = nil
             return
         }
         let imageName = "\(UUID().uuidString.prefix(8)).jpg"
         let imageURL = imageURLPath.appendingPathComponent(imageName)
         if let imageData = image.jpegData(compressionQuality: 0.4) {
             do {
                 try imageData.write(to: imageURL)
                 photoDidSelectk?(imageURL)
             } catch {
                 AppMessage.shared.display(error.localizedDescription)
             }
         }

         picker.dismiss(animated: true, completion: nil)
         photoDidSelectk = nil
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Handle the user canceling the image picker, if needed.
        dismiss(animated: true, completion: nil)
    }
}
