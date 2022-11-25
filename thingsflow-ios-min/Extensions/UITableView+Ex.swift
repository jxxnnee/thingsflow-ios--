//
//  UITableView+Ex.swift
//  thingsflow-ios-min
//
//  Created by 민경준 on 2022/11/25.
//

import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableCell { }
extension UITableViewHeaderFooterView: ReusableCell { }

extension UITableView {
    func register<T: UITableViewCell>(_ cell: T.Type) {
        self.register(cell.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable Dequeue Reusable")
        }
        
        return cell
    }
    
    func register<T: UITableViewHeaderFooterView>(_ view: T.Type) {
        self.register(view.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Unable Dequeue Reusable")
        }
        
        return view
    }
}



