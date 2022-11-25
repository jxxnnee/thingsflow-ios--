//
//  Api.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import Alamofire

struct Api {
    static let `default` = Api()
    
    fileprivate let decoder = JSONDecoder().then {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }
    func getRepository(owner: String, repo: String, completionHandler: @escaping (DataResponse<Repo, AFError>) -> Void) {
        AF.request(
            "https://api.github.com/repos/\(owner)/\(repo)",
            method: .get,
            parameters: nil,
            headers: ["Accept": "application/vnd.github+json"])
        .responseDecodable(of: Repo.self, decoder: self.decoder) { res in
            completionHandler(res)
        }
    }
    func getIssues(owner: String, repo: String, completionHandler: @escaping (DataResponse<[Issue], AFError>) -> Void) {
        AF.request(
            "https://api.github.com/repos/\(owner)/\(repo)/issues",
            method: .get,
            parameters: nil,
            headers: ["Accept": "application/vnd.github+json"])
        .responseDecodable(of: [Issue].self, decoder: self.decoder) { res in
            completionHandler(res)
        }
    }
}
