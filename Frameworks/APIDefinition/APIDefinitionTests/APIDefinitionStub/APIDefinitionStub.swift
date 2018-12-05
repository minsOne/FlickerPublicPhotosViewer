//
//  APIDefinitionStub.swift
//  APIDefinitionTests
//
//  Created by JungMinAhn on 05/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

@testable import APIDefinition
import Foundation

final class NetworkingHandleStub: NetworkingHandleable {
    func cancel() {}
    func resume() {}
}

final class NetworkingStub: NetworkingProtocol {
    var request: URLRequest?
    func dataTask(with request: URLRequest, completionBlock: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingHandleable {
        self.request = request
        return NetworkingHandleStub()
    }
}

struct APIDefinitionStub: APIDefinition {
    typealias Response = ResponseStub
    let method: HTTPMethod = .GET
    let path = "/services/feeds/photos_public.gne"
    let networking: NetworkingProtocol = NetworkingStub()
}

struct ResponseStub: ResponseDataTypeProtocol {
    init?(data: Data) {}
}
