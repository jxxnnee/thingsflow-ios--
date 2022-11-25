//
//  SnapKit+Ex.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import SnapKit


/// iPhone XS, 11 Pro 기준으로 offset을 기입할 때
/// 다른 핸드폰에서 실행하면 자동으로 계산해서 수치를 변경해준다.
extension ConstraintMakerEditable {
    @discardableResult
    internal func multipliedBy(pixel: ConstraintMultiplierTarget) -> ConstraintMakerEditable {
        let value = pixel.constraintMultiplierTargetValue
        let newValue = Size.default.Bounds.width * (value / 375.000)
        return self.multipliedBy(newValue)
    }
    
    @discardableResult
    internal func dividedBy(pixel: ConstraintMultiplierTarget) -> ConstraintMakerEditable {
        let value = pixel.constraintMultiplierTargetValue
        let newValue = Size.default.Bounds.width * (value / 375.000)
        return self.dividedBy(newValue)
    }

    @discardableResult
    internal func offset(pixel: ConstraintMultiplierTarget) -> ConstraintMakerEditable {
        let value = pixel.constraintMultiplierTargetValue
        let newValue = Size.default.Bounds.width * (value / 375.000)
        return self.offset(newValue)
    }

    @discardableResult
    internal func inset(pixel: ConstraintMultiplierTarget) -> ConstraintMakerEditable {
        let value = pixel.constraintMultiplierTargetValue
        let newValue = Size.default.Bounds.width * (value / 375.000)
        return self.inset(newValue)
    }
    
}


extension ConstraintMakerRelatable {
    @discardableResult
    internal func equalTo(pixel: ConstraintMultiplierTarget) -> ConstraintMakerEditable {
        let value = pixel.constraintMultiplierTargetValue
        let newValue = Size.default.Bounds.width * (value / 375.0000)
        return self.equalTo(newValue)
    }
}

