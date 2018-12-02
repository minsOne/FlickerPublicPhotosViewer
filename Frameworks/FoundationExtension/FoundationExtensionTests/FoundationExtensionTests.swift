//
//  FoundationExtensionTests.swift
//  FoundationExtensionTests
//
//  Created by JungMinAhn on 30/11/2018.
//  Copyright © 2018 kakaobank. All rights reserved.
//

@testable import FoundationExtension
import XCTest

class FoundationExtensionTests: XCTestCase {
    func test_LastIndex() {
        do {
            let list = [Int]()
            XCTAssertNil(list.lastIndex)
        }

        do {
            let list = [1, 2, 3, 4]
            XCTAssertEqual(list.lastIndex, 3)
        }
    }

    func test_IsLast() {
        do {
            let list = [Int]()
            XCTAssertNil(list.isLast(index: 1))
        }

        do {
            let list = [1, 2, 3, 4]
            XCTAssertEqual(list.isLast(index: 3), true)
        }
    }

    func test_subscript() {
        do {
            let list = [Int]()
            XCTAssertNil(list[safe: 0])
        }

        do {
            let list = [1, 2, 3, 4]
            XCTAssertEqual(list[safe: 0], 1)
        }
    }
}
