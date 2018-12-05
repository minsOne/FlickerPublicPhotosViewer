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
    func testRequestURL() {
        // given
        let requestURL = getAPIDefinitionURLRequest(apiDefinition: APIDefinitionStub())
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

    func testRequest() {
        // given
        let apiStub = ResultStringAPIDefinitionStub()
        let expectation = XCTestExpectation()

        // then
        apiStub.request { (result) in
            expectation.fulfill()
            switch result {
            case .value(let value):
                XCTAssertEqual("result", value.result)
            case .error:
                XCTFail()
            }
        }
        let _ = XCTWaiter.wait(for: [expectation], timeout: 5)
    }

    func testEmptyErrorRequest() {
        // given
        let apiStub = EmptyErrorAPIDefinitionStub()
        let expectation = XCTestExpectation()

        // then
        apiStub.request { (result) in
            expectation.fulfill()
            switch result {
            case .value:
                XCTFail()
            case .error(let error) where .데이터없음 == error : break
            case .error:
                XCTFail()
            }
        }
        let _ = XCTWaiter.wait(for: [expectation], timeout: 5)
    }

}

private extension APIDefinitionTests {
    func getAPIDefinitionURLRequest<T: APIDefinition>(apiDefinition: T) -> URLRequest? where T.Response == ResponseStub {
        return apiDefinition.requestURL
    }
}
