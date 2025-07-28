//
//  MainThread.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import Foundation

struct MainThread {
    static func run(block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
