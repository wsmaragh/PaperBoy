//
//  String+.swift
//  PaperBoy
//
//  Created by Winston Maragh on 10/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

// MARK: STRING

extension String {

    func decodeToUTF8() -> String {
        let dataStr = self.data(using: String.Encoding.isoLatin1)
        return String(data: dataStr!, encoding: String.Encoding.utf8)!
    }

}
