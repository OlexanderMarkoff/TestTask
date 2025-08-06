//
//  NSMutableAttributedString+Extensions.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

extension NSMutableAttributedString {

    func addLink(_ linkStr: String, ontoMatchingStr matchingStr: String) {
        let strNS = NSString(string: string)
        let linkRange = strNS.range(of: matchingStr )
        addAttribute(.link, value: linkStr, range: linkRange)
    }

    func fullLengthRange() -> NSRange {
        return NSRange(location: 0, length: length)
    }

    func addAttributeToFullRange(_ attrib: NSAttributedString.Key, value: Any) {
        addAttribute(attrib, value: value, range: fullLengthRange())
    }

    func addAttributeToRangeMatchingString(_ str: String, attrib: NSAttributedString.Key, value: Any) {

        let strNS = NSString(string: string)
        let matchRange = strNS.range(of: str)
        addAttribute(attrib, value: value, range: matchRange)
    }

    func addLineSpacingToFullRange(_ spacing: CGFloat, alignment: NSTextAlignment = .center, lineHeight: CGFloat? = nil) {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineSpacing = spacing
        if let height = lineHeight {
            style.lineHeightMultiple = height
        }
        addAttributeToFullRange(.paragraphStyle, value: style)
    }

    func nsRange(of strToMatch: String) -> NSRange {
        let strNS = NSString(string: string)
        return strNS.range(of: strToMatch)
    }

    @discardableResult func appendWithFont(_ text: String, font: UIFont) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        append(boldString)
        return self
    }

}
