//
//  APIDefinitionResultStub.swift
//  APIDefinitionTests
//
//  Created by JungMinAhn on 05/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

@testable import APIDefinition
import Foundation

final class ResultStringNetworkingStub: NetworkingProtocol {
    func dataTask(with request: URLRequest, completionBlock: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingHandleable {
        completionBlock("result".data(using: .utf8), nil, nil)
        return NetworkingHandleStub()
    }
}

struct ResultStringAPIDefinitionStub: APIDefinition {
    typealias Response = ResultStringResponseStub
    let method: HTTPMethod = .GET
    let path = "/services/feeds/photos_public.gne"
    let networking: NetworkingProtocol = ResultStringNetworkingStub()
}

struct ResultStringResponseStub: ResponseDataTypeProtocol {
    let result: String
    init?(data: Data) {
        guard let r = String(data: data, encoding: .utf8)
            else { return nil }
        self.result = r
    }
}
