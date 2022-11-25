//
//  Repo.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import Foundation

struct Repo: Codable {
    var id: Int             = 0
    var name: String        = ""
    var fullName: String    = ""
    var owner: Owner        = Owner()
    var htmlUrl: String        = ""
}
