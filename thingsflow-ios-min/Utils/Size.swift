//
//  Size.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit

struct Size {
    static let `default` = Size()
    
    var Bounds: CGSize {
        return UIScreen.main.bounds.size
    }
    var window: UIWindow? {
        get {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first { $0.isKeyWindow }
            
            return window
        }
    }
    
    var topSafeAreaHeight: CGFloat {
        get {
            guard let window = self.window else { return 0 }
            
            return window.safeAreaLayoutGuide.layoutFrame.minY
        }
    }
    var botSafeAreaHeight: CGFloat {
        get {
            guard let window = self.window else { return 0 }
            
            return window.frame.maxY - window.safeAreaLayoutGuide.layoutFrame.maxY
        }
    }
    
    func pixel(_ value: Pixel) -> CGFloat {
        return self.Bounds.width * (value.multiplierValue / 375.0000)
    }
}


extension Int: Pixel {
    public var multiplierValue: CGFloat {
        return CGFloat(self)
    }
}

extension UInt: Pixel {
    public var multiplierValue: CGFloat {
        return CGFloat(self)
    }
}

extension Float: Pixel {
    public var multiplierValue: CGFloat {
        return CGFloat(self)
    }
}

extension Double: Pixel {
    public var multiplierValue: CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat: Pixel {
    public var multiplierValue: CGFloat {
        return self
    }
}

