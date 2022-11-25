//
//  IssuListViewSection.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit
import RxDataSources

struct IssueListViewSection {
    typealias Model = SectionModel<Int, Item>
    
    enum Item {
        case issue(Issue)
        case logo
    }
}

