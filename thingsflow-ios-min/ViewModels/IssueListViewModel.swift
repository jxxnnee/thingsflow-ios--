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
    }
    
    struct Output {
        let repository = PublishRelay<ResultItem>()
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
                        print(err.localizedDescription)
                        self.output.repository.accept(.failure(502))
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
}
