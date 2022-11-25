//
//  Protocols.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get set }
    var output: Output { get set }
    
    var disposeBag: DisposeBag { get set }
}

protocol Pixel {
    var multiplierValue: CGFloat { get }
}
