//
//  Result.swift
//  APIDefinition
//
//  Created by minsone on 29/11/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

import Foundation

public enum Result<Value, Error: Swift.Error> {
    case value(Value)
    case error(Error)

    var value: Value? {
        if case .value(let v) = self { return v }
        return nil
    }
    var error: Error? {
        if case .error(let err) = self { return err }
        return nil
    }

    var isSuccess: Bool {
        switch self {
        case .value: return true
        case .error: return false
        }
    }

    var isFailure: Bool {
        return isSuccess.not
    }
}
