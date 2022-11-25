//
//  DictData.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import Foundation

struct DictData: Codable {
    var repo: Repo
    var issues: [Issue]
}
