//
//  AppMessageViewModel.swift
//  TestTask
//
//  Created by Olexander Markov on 30.07.2025.
//

import Foundation

final class AppMessageViewModel: FormViewModel {

    var actionButtonuttonTapped: () -> Void = {}

    private lazy var infoView: AppMessageField = {
        return AppMessageField(tag: -1, model: .noNetwork, buttonuttonTapped: {
            self.actionButtonuttonTapped()
        })

    }()

    override init() {
        super.init()
        sections = [
            FormSection(
                id: -1,
                title: nil,
                cells: [infoView]
            )
        ]
    }
}
