//
//  UserCell.swift
//  TestTask
//
//  Created by Olexander Markov on 01.08.2025.
//

import UIKit

final class UserCell: UITableViewCell {

    @IBOutlet weak var userAvatarImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPositionLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        userAvatarImg.layer.cornerRadius = 25.0
        userAvatarImg.layer.masksToBounds = true

        userNameLabel.applyStyle(.textBody2)
        userPositionLabel.applyStyle(.textBody3Light)
        userEmailLabel.applyStyle(.textBody3)
        userPhoneLabel.applyStyle(.textBody3)

    }

    func configure(with model: UserFieldModel) {
        userNameLabel.text = model.userName
        userPositionLabel.text = model.userPosition
        userEmailLabel.text = model.userMail
        userPhoneLabel.text = model.userPhone

            loadAvatar(model: model)
    }

    func loadAvatar(model: UserFieldModel) {
        userAvatarImg.image = .initialsImage(
            text: model.userName.first.map(String.init) ?? "_",
            size: CGSize(width: 50, height: 50),
            textColor: .white,
            backgroundColor: .purple,
        )

        if let url = URL(string: model.avatarUrl) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
          guard let imageData = data else { return }

          DispatchQueue.main.async {
            self.userAvatarImg.image = UIImage(data: imageData)
          }
        }.resume()
      }
    }
}
