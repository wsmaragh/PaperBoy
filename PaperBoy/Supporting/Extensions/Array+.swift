//
//  Array+.swift
//  PaperBoy
//
//  Created by winston on 1/2/19.
//  Copyright © 2019 Winston Maragh. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func next(item: Element) -> Element? {
        if let index = self.index(of: item), index + 1 <= self.count {
            return index + 1 == self.count ? self[0] : self[index + 1]
        }
        return nil
    }
    
    func prev(item: Element) -> Element? {
        if let index = self.index(of: item), index >= 0 {
            return index == 0 ? self.last : self[index - 1]
        }
        return nil
    }
}
