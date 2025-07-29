//
//  UIImage+TestTask.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

extension UIImage {
    func draw(text: String) -> UIImage? {
        let text = NSString(string: text)
        let fontAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: FontFamily.NunitoSans.regular.font(size: 16) ??  UIFont.systemFont(ofSize: 20.0),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]

        let scale = UIScreen.main.scale
        let textSize = text.size(withAttributes: fontAttributes)
        let xOffset: CGFloat = 8

        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width + textSize.width + xOffset, height: size.height), false, scale)
        defer { UIGraphicsEndImageContext() }

        draw(at: .zero)

        text.draw(at: CGPoint(x: size.width + xOffset, y: size.height/2 - textSize.height/2), withAttributes: fontAttributes)

        let newImage =  UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
}
