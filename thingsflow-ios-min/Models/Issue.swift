//
//  Issue.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import Foundation

struct Issue: Codable {
    var id: Int
    var number: Int
    var title: String
    var body: String?
    var url: String
    var htmlUrl: String
    var user: Owner
}
