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
        let getRepository = PublishSubject<Info>()
        let getRepoIssues = PublishSubject<Info>()
    }
    
    struct Output {
        let repository = PublishRelay<ResultItem>()
        let issues = PublishRelay<ResultItem>()
    }
    
    var input: Input = Input()
    var output: Output = Output()
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
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
                        print(err)
                        self.output.repository.accept(.failure(502))
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
                        let section = IssueListViewSection(items: items)
                        self.output.issues.accept(.success(section))
                    case .failure(let err):
                        print(err)
                        self.output.issues.accept(.failure(502))
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
}
