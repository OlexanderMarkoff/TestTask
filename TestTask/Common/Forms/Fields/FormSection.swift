//
//  FormSection.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

struct FormSection {
    let id: Int
    var title: String?
    var titleStyle: TextStyle = .textH1
    var subtitle: String?
    var subtitleStyle: TextStyle = .textBody1
    var cells: [FormField]
}
