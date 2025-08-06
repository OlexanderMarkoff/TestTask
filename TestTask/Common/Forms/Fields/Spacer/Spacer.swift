//
//  Spacer.swift
//  TestTask
//
//  Created by Olexander Markov on 03.08.2025.
//

import UIKit

final class Spacer: FormField {

    let reuseIdentifier: String = "SpacerView"
    let nibName: String = "SpacerView"

    let tag: Int
    let height: CGFloat
    var isVisible = true

    init(height: CGFloat, tag: Int = -1) {
        self.height = height
        self.tag = tag
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return isVisible ? height : 0
    }
}
