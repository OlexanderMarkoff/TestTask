//
//  LoaderField.swift
//  TestTask
//
//  Created by Olexander Markov on 01.08.2025.
//

import Foundation

final class LoaderField: FormField {
    var reuseIdentifier: String = "LoaderCell"
    var nibName: String = "LoaderCell"
    var tag: Int = -1

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 48
    }

}
