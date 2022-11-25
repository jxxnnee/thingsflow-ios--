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
import CoreMIDI

class IssueListViewController: UIViewController {
    // MARK: Fileprivate
    fileprivate var repoData = Repo()
    fileprivate var issueArr: [Issue] = []
    
    fileprivate let searchButton = UIButton().then {
        $0.setTitleColor(.link, for: .normal)
        $0.setTitle("Search", for: .normal)
    }
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(IssueListViewCell.self)
        $0.register(IssueListHeaderView.self)
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100.0
    }
    fileprivate let indicatorView = UIActivityIndicatorView()
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<IssueListViewSection.Model>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
        let cell: IssueListViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        
        switch item {
        case .issue(let issue):
            cell.issue = issue
        case .logo:
            cell.setLogo()
        }
        
        return cell
    })
    
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
                self.setDelegates()
                
                viewModel.input.checkLastData.onNext(())
            })
            .disposed(by: self.disposeBag)
        
        self.rx.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.navigationController?.setNavigationBarHidden(true, animated: true)
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
                
                switch result {
                case .success(let item):
                    guard let repo = item as? Repo else {
                        self.stopIndicator()
                        self.errorAlertView(title: "Error", message: "캐스팅 에러입니다.")
                        return
                    }
                    
                    self.repoData = repo
                    let info = Info(organization: repo.owner.login, repository: repo.name)
                    viewModel.input.getRepoIssues.onNext(info)
                case .failure(let statusCode):
                    self.errorControl(statusCode: statusCode)
                }
            })
            .disposed(by: self.disposeBag)
        
        viewModel.output.issues
            .map { [weak self] result -> IssueListViewSection.Model? in
                guard let self = self else { return nil }
                
                switch result {
                case .success(let section):
                    guard let section = section as? IssueListViewSection.Model else {
                        self.errorAlertView(title: "Error", message: "캐스팅 에러입니다.")
                        return nil
                    }
                    
                    self.stopIndicator()
                    self.issueArr = section.items.map { data -> Issue? in
                        if case let .issue(item) = data { return item }
                        else { return nil }
                    }.compactMap { $0 }
                    
                    let dictData = DictData(repo: self.repoData, issues: self.issueArr)
                    viewModel.input.setData.onNext(dictData)
                    
                    return section
                case .failure(let statusCode):
                    self.errorControl(statusCode: statusCode)
                    
                    return nil
                }
            }
            .compactMap { $0 }
            .map { Array.init(with: $0) }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}



extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: IssueListHeaderView = tableView.dequeueReusableHeaderFooterView()
        headerView.title = self.repoData.fullName
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !(indexPath.row == 4) else { return }
        let indexRow = indexPath.row > 4 ? indexPath.row - 1 : indexPath.row
        let data = self.issueArr[indexRow]
        
        let issueDetailViewController = IssueDetailViewController()
        issueDetailViewController.issue = data
        issueDetailViewController.repoName = self.repoData.fullName
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.repoData.fullName, style: .plain, target: self, action: nil)
        
        self.navigationController?.pushViewController(issueDetailViewController, animated: true)
    }
}




extension IssueListViewController {
    fileprivate func setDelegates() {
        self.tableView.delegate = self
    }
    fileprivate func setViewLayout() {
        self.view.addSubview(self.searchButton)
        self.searchButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperViewSafeArea().inset(pixel: 20)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchButton.snp.bottom).offset(pixel: 10)
            make.leading.trailing.bottom.equalToSuperViewSafeArea()
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
            viewModel.input.getRepository.onNext(info)
        })
        
        alertView.addAction(cancel)
        alertView.addAction(confirm)
        
        self.present(alertView, animated: true)
    }
    fileprivate func errorAlertView(title: String, message: String) {
        self.stopIndicator()
        
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

