//
//  Font.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit

struct Font {
    static let `default` = Font()
    
    var attrString: NSMutableAttributedString {
        get {
            let attrStr = NSMutableAttributedString()
            
            return attrStr
        }
    }
}


extension NSMutableAttributedString {
    func regular(string: String, fontSize: CGFloat, color: UIColor = .black, spacing: CGFloat = 0.0, baseline: CGFloat = 0.0, underline: Bool = false) -> NSMutableAttributedString {
        /// FontSize를 기종의 크기 비율에 맞게 나오도록 계산해서 사용한다.
        return self.base(string: string, fontSize: fontSize, weight: .regular, color: color, spacing: spacing, baseline: baseline, underline: underline)
    }
    func semibold(string: String, fontSize: CGFloat, color: UIColor = .black, spacing: CGFloat = 0.0, baseline: CGFloat = 0.0, underline: Bool = false) -> NSMutableAttributedString {
        /// FontSize를 기종의 크기 비율에 맞게 나오도록 계산해서 사용한다.
        return self.base(string: string, fontSize: fontSize, weight: .semibold, color: color, spacing: spacing, baseline: baseline, underline: underline)
    }
    func bold(string: String, fontSize: CGFloat, color: UIColor = .black, spacing: CGFloat = 0.0, baseline: CGFloat = 0.0, underline: Bool = false) -> NSMutableAttributedString {
        /// FontSize를 기종의 크기 비율에 맞게 나오도록 계산해서 사용한다.
        return self.base(string: string, fontSize: fontSize, weight: .bold, color: color, spacing: spacing, baseline: baseline, underline: underline)
    }
    func medium(string: String, fontSize: CGFloat, color: UIColor = .black, spacing: CGFloat = 0.0, baseline: CGFloat = 0.0, underline: Bool = false) -> NSMutableAttributedString {
        /// FontSize를 기종의 크기 비율에 맞게 나오도록 계산해서 사용한다.
        return self.base(string: string, fontSize: fontSize, weight: .medium, color: color, spacing: spacing, baseline: baseline, underline: underline)
    }
    func light(string: String, fontSize: CGFloat, color: UIColor = .black, spacing: CGFloat = 0.0, baseline: CGFloat = 0.0, underline: Bool = false) -> NSMutableAttributedString {
        /// FontSize를 기종의 크기 비율에 맞게 나오도록 계산해서 사용한다.
        return self.base(string: string, fontSize: fontSize, weight: .light, color: color, spacing: spacing, baseline: baseline, underline: underline)
    }
    func thin(string: String, fontSize: CGFloat, color: UIColor = .black, spacing: CGFloat = 0.0, baseline: CGFloat = 0.0, underline: Bool = false) -> NSMutableAttributedString {
        /// FontSize를 기종의 크기 비율에 맞게 나오도록 계산해서 사용한다.
        return self.base(string: string, fontSize: fontSize, weight: .thin, color: color, spacing: spacing, baseline: baseline, underline: underline)
    }
    fileprivate func base(string: String, fontSize: CGFloat, weight: UIFont.Weight, color: UIColor = .black, spacing: CGFloat = 0.0, baseline: CGFloat = 0.0, underline: Bool = false) -> NSMutableAttributedString {
        
        let newSize = Size.default.pixel(fontSize)
        let name = "AppleSDGothicNeo-" + self.weightString(weight)
        let newBase = Size.default.pixel(baseline)
        
        var attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont(name: name, size: newSize),
            .foregroundColor: color,
            .kern: spacing,
            .baselineOffset: newBase
        ]
        if underline {
            attrs[.underlineStyle] = NSUnderlineStyle.thick.rawValue
        }
        self.append(NSMutableAttributedString(string: string, attributes: attrs))
        
        return self
    }
    fileprivate func weightString(_ weight: UIFont.Weight) -> String {
        switch weight {
        case .bold:
            return "Bold"
        case .semibold:
            return "Semibold"
        case .regular:
            return "Regular"
        case .light:
            return "Light"
        case .medium:
            return "Medium"
        case .thin:
            return "Thin"
        default:
            return "regular"
        }
    }
}
