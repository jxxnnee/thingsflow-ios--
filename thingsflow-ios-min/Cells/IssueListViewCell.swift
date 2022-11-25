//
//  IssueListViewCell.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit
import Kingfisher

class IssueListViewCell: UITableViewCell {
    public var issue: Issue? {
        didSet {
            guard let issue = issue else { return }
            
            self.titleLabel.attributedText = Font.default.attrString.regular(string: "\(issue.number): \(issue.title)", fontSize: 15)
            
            self.setViewLayout()
        }
    }
    
    fileprivate let logoView = UIImageView().then {
        let url = URL(string: "https://s3.ap-northeast-2.amazonaws.com/hellobot-kr-test/image/main_logo.png")
        $0.kf.setImage(with: url)
        $0.clipsToBounds = true
    }
    fileprivate let titleLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLogo() {
        self.contentView.addSubview(self.logoView)
        self.logoView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.contentView).inset(pixel: 20)
            make.width.equalTo(pixel: 355.0)
            make.height.equalTo(pixel: 62)
        }
    }
    fileprivate func setViewLayout() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.contentView).inset(pixel: 20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { view in
            view.snp.removeConstraints()
            view.removeFromSuperview()
        }
    }
}
