//
//  IssueListViewModel.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import Foundation
import RxSwift
import RxRelay

class IssueListViewModel: ViewModelType {
    enum ResultItem {
        case success(Any)
        case failure(Int)
    }
    
    struct Input {
        let checkLastData = PublishSubject<Void>()
        let getRepository = PublishSubject<Info>()
        let getRepoIssues = PublishSubject<Info>()
        let setData = PublishSubject<DictData>()
    }
    
    struct Output {
        let repository = PublishRelay<ResultItem>()
        let issues = PublishRelay<ResultItem>()
    }
    
    var input: Input = Input()
    var output: Output = Output()
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        self.input.checkLastData
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                do {
                    guard let data = try self.getLastInfoData() else { return }
                    
                    Api.default.getRepository(owner: data.organization, repo: data.repository) { res in
                        guard let statusCode = res.response?.statusCode else {
                            self.output.repository.accept(.failure(501))
                            return
                        }
                        guard statusCode == 200 else {
                            self.output.repository.accept(.failure(statusCode))
                            return
                        }
                        
                        switch res.result {
                        case .success(let item):
                            self.output.repository.accept(.success(item))
                        case .failure(let err):
                            do {
                                if err._code == NSURLErrorTimedOut, let data = try self.getDictData(name: "\(data.organization)/\(data.repository)") {
                                    self.output.repository.accept(.success(data.repo))
                                } else {
                                    print(err)
                                    self.output.repository.accept(.failure(502))
                                }
                            } catch {
                                print("GET USER DEFAULTS REPO DATA ERROR")
                                self.output.repository.accept(.failure(502))
                            }
                        }
                    }
                } catch {
                    print("GET USER DEFAULTS LAST DATA ERROR")
                    self.output.repository.accept(.failure(502))
                }
            })
            .disposed(by: self.disposeBag)
        self.input.getRepository
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                
                Api.default.getRepository(owner: item.organization, repo: item.repository) { res in
                    guard let statusCode = res.response?.statusCode else {
                        self.output.repository.accept(.failure(501))
                        return
                    }
                    guard statusCode == 200 else {
                        self.output.repository.accept(.failure(statusCode))
                        return
                    }
                    
                    switch res.result {
                    case .success(let item):
                        self.output.repository.accept(.success(item))
                    case .failure(let err):
                        do {
                            if err._code == NSURLErrorTimedOut, let data = try self.getDictData(name: "\(item.organization)/\(item.repository)") {
                                self.output.repository.accept(.success(data.repo))
                            } else {
                                print(err)
                                self.output.repository.accept(.failure(502))
                            }
                        } catch {
                            print("GET USER DEFAULTS REPO DATA ERROR")
                            self.output.repository.accept(.failure(502))
                        }
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        self.input.getRepoIssues
            .subscribe(onNext: { [weak self ] info in
                guard let self = self else { return }
                
                Api.default.getIssues(owner: info.organization, repo: info.repository) { res in
                    guard let statusCode = res.response?.statusCode else {
                        self.output.issues.accept(.failure(501))
                        return
                    }
                    guard statusCode == 200 else {
                        self.output.issues.accept(.failure(statusCode))
                        return
                    }
                    
                    switch res.result {
                    case .success(let items):
                        var cells = items.map(IssueListViewSection.Item.issue)
                        cells.insert(.logo, at: 4)
                        
                        let section = IssueListViewSection.Model.init(model: 0, items: cells)
                        self.output.issues.accept(.success(section))
                    case .failure(let err):
                        do {
                            if err._code == NSURLErrorTimedOut, let dict = try self.getDictData(name: "\(info.organization)/\(info.repository)") {
                                
                                self.output.issues.accept(.success(dict.issues))
                            } else {
                                print(err)
                                self.output.issues.accept(.failure(502))
                            }
                        } catch {
                            print(err)
                            self.output.issues.accept(.failure(502))
                        }
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        self.input.setData
            .subscribe(onNext: { [weak self] item in
                let info = Info(organization: item.repo.owner.login, repository: item.repo.name)
                
                do {
                    try self?.setLastInfoData(info: info)
                    try self?.setDictData(data: item)
                } catch {
                    print("SET USER DEFAULTS ERROR")
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func setLastInfoData(info: Info) throws {
        let encodeData = try PropertyListEncoder().encode(info)
        UserDefaults.standard.set(encodeData, forKey: Const.default.lastRepo)
        UserDefaults.standard.synchronize()
    }
    fileprivate func getLastInfoData() throws -> Info? {
        guard let data = UserDefaults.standard.data(forKey: Const.default.lastRepo) else { return nil }
        let info = try PropertyListDecoder().decode(Info.self, from: data)
        return info
    }
    
    fileprivate func setDictData(data: DictData) throws {
        /// Set Dict Data
        /// key -> "owner/repository"
        let encodeData = try PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encodeData, forKey: data.repo.fullName)
        UserDefaults.standard.synchronize()
    }
    fileprivate func getDictData(name: String) throws -> DictData? {
        /// name -> "owner/repository"
        guard let data = UserDefaults.standard.data(forKey: name) else { return nil }
        let dict = try PropertyListDecoder().decode(DictData.self, from: data)
        return dict
    }
}
