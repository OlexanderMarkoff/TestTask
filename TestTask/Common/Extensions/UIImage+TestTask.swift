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

    static func initialsImage(text: String, size: CGSize, textColor: UIColor, backgroundColor: UIColor, fontSize: CGFloat = 24) -> UIImage {
        let drawingRect = CGRect(origin: .zero, size: size)

        let label = UILabel()
        label.text = text
        label.frame = drawingRect
        label.textColor = textColor
        label.textAlignment = .center
        label.backgroundColor = backgroundColor
        label.font = FontFamily.NunitoSans.semiBold.font(size: fontSize)

        let format = UIGraphicsImageRendererFormat(for: .init(displayScale: UIScreen.main.scale))
        let renderer = UIGraphicsImageRenderer(bounds: drawingRect, format: format)
        return renderer.image { context in
            backgroundColor.setFill()
            context.fill(drawingRect)
            label.layer.draw(in: context.cgContext)
        }
    }
}
