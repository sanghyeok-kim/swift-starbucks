//
//  NSMutableAttributedString+Extension.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/12.
//

import UIKit

enum AttributedStringOption {
    case font(_ font: UIFont)
    case foreground(color: UIColor)
    case background(color: UIColor)
    case underLined
    case strikethrough
    case paragraphStyle(_ style: NSMutableParagraphStyle)
}

extension NSAttributedString {
    static func create(_ string: String, options: [AttributedStringOption] = []) -> NSAttributedString {
        var attributes = [NSAttributedString.Key: Any]()
        options.forEach { option in
            switch option {
            case .font(let font):
                attributes[.font] = font
            case .foreground(let color):
                attributes[.foregroundColor] = color
            case .background(let color):
                attributes[.backgroundColor] = color
            case .underLined:
                attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            case .strikethrough:
                attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            case .paragraphStyle(let style):
                attributes[.paragraphStyle] = style
            }
        }
        return NSAttributedString(string: string, attributes: attributes)
    }
}

extension NSMutableAttributedString {
    
    func addStrings(_ strings: [NSAttributedString]) -> NSMutableAttributedString {
        strings.forEach {
            self.append($0)
        }
        return self
    }
}
