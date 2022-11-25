//
//  IssueListHeaderView.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit

class IssueListHeaderView: UITableViewHeaderFooterView {
    public var title: String = "" {
        didSet {
            self.titleLabel.attributedText = Font.default.attrString.bold(string: self.title, fontSize: 30)
        }
    }
    fileprivate var titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.setViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setViewLayout() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(pixel: 10)
        }
    }
}
