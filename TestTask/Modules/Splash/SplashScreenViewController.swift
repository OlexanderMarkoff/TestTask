//
//  SplashScreenViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

final class SplashScreenViewController: UIViewController, Storyboarded {

    var goToMain: () -> Void = { print("goToMain not overridden") }

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.goToMain()
            self.stopTimer()
        }

    }

    // timer just to make some delay before main screen shown
    var timer: Timer?
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

}
