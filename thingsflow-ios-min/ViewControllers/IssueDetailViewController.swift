//
//  IssueDetailViewController.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit
import RxSwift

class IssueDetailViewController: UIViewController {
    // MARK: Public
    public var issue: Issue? {
        didSet {
            guard let issue = issue else {
                return
            }
            
            self.bind()
            self.setTitleView(issue.user)
            
            if let body = issue.body {
                self.bodyLabel.attributedText = Font.default.attrString.regular(string: body, fontSize: 15)
            }
        }
    }
    public var repoName: String = ""
    public var disposeBag = DisposeBag()
    
    // MARK: Fileprivate
    fileprivate let titleView = UIView()
    fileprivate let bodyLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    fileprivate let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    fileprivate let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .top
        $0.spacing = Size.default.pixel(5)
    }
}



extension IssueDetailViewController {
    fileprivate func bind() {
        self.rx.viewDidLoad
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.view.backgroundColor = .white
                self.setViewLayout()
                
                
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}




extension IssueDetailViewController {
    fileprivate func setViewLayout() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperViewSafeArea()
        }
        
        self.scrollView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.width.equalTo(pixel: 335)
            make.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            make.leading.trailing.equalTo(self.scrollView.contentLayoutGuide).inset(pixel: 20)
        }
        
        self.stackView.addArrangedSubview(self.titleView)
        self.titleView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(pixel: 100)
        }
        
        self.stackView.addArrangedSubview(self.bodyLabel)
        self.bodyLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    fileprivate func setTitleView(_ user: Owner) {
        let imageView = UIImageView().then {
            let url = URL(string: user.avatarUrl)
            $0.kf.setImage(with: url)
            $0.clipsToBounds = true
        }
        
        let imageSize = CGSize(wp: 60, hp: 60)
        imageView.frame.size = imageSize
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        self.titleView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.size.equalTo(imageSize)
        }
        
        let name = UILabel().then {
            $0.attributedText = Font.default.attrString.semibold(string: user.login, fontSize: 15)
        }
        
        self.titleView.addSubview(name)
        name.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(pixel: 5)
            make.centerY.equalTo(imageView)
        }
    }
}
