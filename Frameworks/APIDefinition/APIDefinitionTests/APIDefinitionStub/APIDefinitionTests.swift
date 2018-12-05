//
//  APIDefinitionTests.swift
//  APIDefinitionTests
//
//  Created by minsone on 29/11/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

@testable import APIDefinition
import XCTest

final class APIDefinitionTests: XCTestCase {
    func testFlickerImageList() {
        // given
        let requestURL = APIDefinitionStub().requestURL
        let networking = NetworkingStub()

        // when
        guard let request = requestURL else {
            XCTFail()
            return
        }
        let _ = networking.dataTask(with: request) { _, _, _ in }

        // then
        XCTAssertEqual(networking.request?.url?.absoluteString,
                       request.url?.absoluteString)
        XCTAssertEqual(networking.request?.httpMethod,
                       request.httpMethod)
    }
}
