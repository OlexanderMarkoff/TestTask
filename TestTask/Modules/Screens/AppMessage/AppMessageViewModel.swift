//
//  AppMessageViewModel.swift
//  TestTask
//
//  Created by Olexander Markov on 30.07.2025.
//

import Foundation

final class AppMessageViewModel: FormViewModel {

    var actionButtonuttonTapped: () -> Void = {}

    let appMessageModel: AppMessageModel

   private lazy var infoView: AppMessageField = {
        return AppMessageField(tag: -1, model: appMessageModel, buttonuttonTapped: {
            self.actionButtonuttonTapped()
        })

    }()

    init(appMessageModel: AppMessageModel) {
        self.appMessageModel = appMessageModel
        super.init()
        sections = [
            FormSection(
                id: -1,
                title: nil,
                cells: [infoView]
            )
        ]
    }}
