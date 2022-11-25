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
    
    var intput: Input 
    var output: Output
    
    var disposeBag: DisposeBag
}


