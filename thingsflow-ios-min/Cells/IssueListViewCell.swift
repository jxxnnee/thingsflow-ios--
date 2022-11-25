//
//  IssueListViewCell.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit

class IssueListViewCell: UITableViewCell {
    public var issue: Issue? {
        didSet {
            guard let issue = issue else { return }
            
            self.titleLabel.attributedText = Font.default.attrString.regular(string: "\(issue.number): \(issue.title)", fontSize: 15)
        }
    }
    
    fileprivate let titleLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setViewLayout() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.contentView).inset(pixel: 20)
        }
    }
}
