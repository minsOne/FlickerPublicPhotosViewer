//
//  Array+Extension.swift
//  FoundationExtension
//
//  Created by JungMinAhn on 30/11/2018.
//  Copyright © 2018 kakaobank. All rights reserved.
//

import Foundation

public extension Array {
    var lastIndex: Int? {
        return isEmpty
            ? nil
            : (count - 1)
    }

    func isLast(index: Int) -> Bool? {
        return (index < count)
            ? (index == (count - 1))
            : nil
    }

    subscript (safe index: Int) -> Element? {
        return indices ~= index
            ? self[index]
            : nil
    }
}

public extension Array where Element: Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}
