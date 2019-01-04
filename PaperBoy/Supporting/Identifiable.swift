//
//  Identifiable.swift
//  PaperBoy
//
//  Created by winston on 1/4/19.
//  Copyright © 2019 Winston Maragh. All rights reserved.
//


import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: Identifiable { }
extension UIView: Identifiable { }
