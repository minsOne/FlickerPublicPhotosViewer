//
//  APIDefinitionErrorStub.swift
//  APIDefinitionTests
//
//  Created by JungMinAhn on 05/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

@testable import APIDefinition
import Foundation

final class EmptyErrorNetworkingStub: NetworkingProtocol {
    func dataTask(with request: URLRequest, completionBlock: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingHandleable {
        completionBlock(nil, nil, nil)
        return NetworkingHandleStub()
    }
}

struct EmptyErrorAPIDefinitionStub: APIDefinition {
    typealias Response = ResultStringResponseStub
    let method: HTTPMethod = .GET
    let path = "/services/feeds/photos_public.gne"
    let networking: NetworkingProtocol = EmptyErrorNetworkingStub()
}
