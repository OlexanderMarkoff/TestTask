//
//  LoaderCell.swift
//  TestTask
//
//  Created by Olexander Markov on 01.08.2025.
//

import UIKit

final class LoaderCell: UITableViewCell {

    @IBOutlet weak var LoadingView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        LoadingView.startAnimating()
    }

}
