//
//  SpacerView.swift
//  TestTask
//
//  Created by Olexander Markov on 03.08.2025.
//

import UIKit

class SpacerView: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }
}
