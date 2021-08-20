//
//  ErrorHelper.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import Foundation

class ErrorHelper {
    static func set(Error err: String, code: Int) -> NSError {
        return NSError(domain: err, code: code, userInfo: nil)
    }
    
    static func setErrorType(_ err: ErrorType) -> NSError {
        return NSError(domain: err.rawValue, code: 404, userInfo: nil)
    }
    
    private init() { }
    
    enum ErrorType: String {
        case serverError
    }
}

extension Error {
    var domain: String {
        return (self as NSError).domain
    }
    
    var code: Int {
        return (self as NSError).code
    }
}
