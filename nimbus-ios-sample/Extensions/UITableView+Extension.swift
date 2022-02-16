//
//  UITableView+Extension.swift
//  nimbus-ios-sample
//
//  Created by Victor Takai on 15/11/21.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: T.nameOfClass)
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: T.nameOfClass)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.nameOfClass, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.nameOfClass)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: T.nameOfClass) as? T else {
            fatalError("Could not dequeue header with identifier: \(T.nameOfClass)")
        }
        return header
    }
}
