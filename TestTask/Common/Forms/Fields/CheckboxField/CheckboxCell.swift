//
//  CheckboxCell.swift
//  TestTask
//
//  Created by Olexander Markov on 04.08.2025.
//

import UIKit

final class CheckboxCell: UITableViewCell {

    @IBOutlet weak var checkboxImg: UIImageView!
    @IBOutlet weak var checkboxLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        checkboxImg.image = Asset.checkboxUnselected.image
        checkboxLabel.applyStyle(.textBody1)
    }

    func configure(with model: CheckboxFieldModel) {
        checkboxImg.image = model.isSelected ? Asset.checkboxSelected.image : Asset.checkboxUnselected.image
        checkboxLabel.text = model.title
        checkboxLabel.applyStyle(model.titleStyle)
    }
}
