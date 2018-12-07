//
//  APIDefinition.swift
//  APIDefinition
//
//  Created by minsone on 29/11/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

import Foundation
import FoundationExtension

public enum APIDefinitionError: Swift.Error, Equatable {
    case URL생성실패
    case 데이터가져오기실패
    case 네트워크요청에러(NSError)
    case 데이터없음
}

public protocol ResponseDataTypeProtocol {
    init?(data: Data)
}

public protocol NetworkingHandleable {
    func cancel()
    func resume()
}

extension URLSessionDataTask: NetworkingHandleable {}

public protocol NetworkingProtocol {
    func dataTask(with request: URLRequest, completionBlock: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingHandleable
}

extension URLSession: NetworkingProtocol {
    public func dataTask(with request: URLRequest, completionBlock: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingHandleable {
        return dataTask(with: request, completionHandler: completionBlock)
    }
}

public protocol APIDefinition {
    associatedtype Response: ResponseDataTypeProtocol

    var baseURL: URL { get }

    var method: HTTPMethod { get }

    var path: String { get }

    var networking: NetworkingProtocol { get }
}

public extension APIDefinition {
    var baseURL: URL {
        return URL(string: "https://api.flickr.com")!
    }

    var requestURL: URLRequest? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = path
        guard let url = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return request
    }

    var networking: NetworkingProtocol {
        return URLSession.shared
    }

    func request(completion: @escaping ((Result<Response, APIDefinitionError>) -> Void)) {
        guard let request = requestURL else {
            completion(.error(.URL생성실패))
            return
        }

        let task = networking.dataTask(with: request) { data, _, error in
            if let data = data,
                let resp = Response(data: data) {
                completion(.value(resp))
            } else if let error = error as NSError? {
                completion(.error(.네트워크요청에러(error)))
            } else {
                completion(.error(.데이터없음))
            }
        }

        task.resume()
    }
}
