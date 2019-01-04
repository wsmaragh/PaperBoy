\//
//  UITableView+.swift
//  PaperBoy
//
//  Created by winston on 1/4/19.
//  Copyright © 2019 Winston Maragh. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ reuseableViewClass: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func register<T: NibInitializable & UITableViewCell>(_ reusableViewClassWithNib: T.Type, bundle: Bundle? = nil) {
        register(UINib(nibName: T.nibName, bundle: bundle), forCellReuseIdentifier: T.identifier)
    }
    
    func dequeue<T: UITableViewCell>(_ type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: T.identifier) as? T
    }
    
    func dequeue<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T !! T()
    }
    
    func register<T: NibInitializable & UITableViewHeaderFooterView>(_ reusableViewClassWithNib: T.Type, bundle: Bundle? = nil) {
        register(UINib(nibName: T.nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: T.identifier)
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: type.identifier) as? T
    }
    
}
