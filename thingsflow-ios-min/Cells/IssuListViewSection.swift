//
//  IssuListViewSection.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit
import RxDataSources

struct IssueListViewSection {
    var items: [Issue]
    
    init(items: [Issue]) {
        self.items = items
    }
}

extension IssueListViewSection: SectionModelType {
    typealias Item = Issue
    
    init(original: IssueListViewSection, items: [Issue]) {
        self = original
        self.items = items
    }
}
