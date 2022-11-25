//
//  ViewController.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class IssueListViewController: UIViewController {
    // MARK: Fileprivate
    fileprivate let searchButton = UIButton().then {
        $0.setTitleColor(.link, for: .normal)
        $0.setTitle("Search", for: .normal)
    }
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
    }
    fileprivate let indicatorView = UIActivityIndicatorView()
    
    
    // MARK: Public
    public var viewModel: IssueListViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            self.bind(viewModel: viewModel)
        }
    }
    
    public var disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension IssueListViewController {
    fileprivate func bind(viewModel: IssueListViewModel) {
        self.rx.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.view.backgroundColor = .white
                self.setViewLayout()
            })
            .disposed(by: self.disposeBag)
        
        self.searchButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.searchAlertView()
            })
            .disposed(by: self.disposeBag)
        
        viewModel.output.repository
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.stopIndicator()
                switch result {
                case .success(let item):
                    print(item)
                case .failure(let statusCode):
                    self.errorControl(statusCode: statusCode)
                }
            })
            .disposed(by: self.disposeBag)
    }
}




extension IssueListViewController {
    fileprivate func setViewLayout() {
        self.view.addSubview(self.searchButton)
        self.searchButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperViewSafeArea().inset(pixel: 20)
        }
    }
    fileprivate func startIndicator() {
        self.indicatorView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        self.indicatorView.color = .brown
        
        self.indicatorView.frame = self.view.frame
        self.view.addSubview(self.indicatorView)
        self.view.bringSubviewToFront(self.indicatorView)
        self.indicatorView.startAnimating()
    }
    fileprivate func stopIndicator() {
        self.indicatorView.stopAnimating()
        self.indicatorView.removeFromSuperview()
    }
    fileprivate func searchAlertView() {
        let alertView = UIAlertController(title: "검색", message: "찾고 싶은 Repository를 입력하세요.", preferredStyle: .alert)
        
        alertView.addTextField() {
            $0.placeholder = "Organization"
        }
        
        alertView.addTextField() {
            $0.placeholder = "Repostiory"
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let confirm = UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            
            guard let organization = alertView.textFields?[0].text,
                  let repository = alertView.textFields?[1].text else {
                self.errorAlertView(title: "Error", message: "알 수 없는 에러입니다.")
                return
            }
            
            guard !organization.isEmpty, !repository.isEmpty else {
                self.errorAlertView(title: "Error", message: "빈 공간을 모두 채워주세요.")
                return
            }
            
            
            guard let viewModel = self.viewModel else {
                self.errorAlertView(title: "Error", message: "이니셜라이징 에러입니다.")
                return
            }
            let info = Info(organization: organization, repository: repository)
            self.startIndicator()
            print("Info: ", info)
            viewModel.input.getRepository.onNext(info)
        })
        
        alertView.addAction(cancel)
        alertView.addAction(confirm)
        
        self.present(alertView, animated: true)
    }
    fileprivate func errorAlertView(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertView.addAction(action)
        self.present(alertView, animated: true)
    }
    fileprivate func errorControl(statusCode: Int) {
        let title = "Error: \(statusCode)"
        var message = ""
        
        switch statusCode {
        case 301:
            message = "Moved permanently"
        case 403:
            message = "Forbidden"
        case 404:
            message = "Resource not found"
        case 502:
            message = "디코딩 에러입니다."
        default:
            message = "알 수 없는 에러입니다."
        }
        
        self.errorAlertView(title: title, message: message)
    }
}

