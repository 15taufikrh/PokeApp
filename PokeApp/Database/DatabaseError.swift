//
//  DatabaseError.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2019 TMLI IT DEV. All rights reserved.
//

import Foundation

enum DatabaseError: Error {
    case writeError
    case readError
    case invalidAttributes
    case attributesNotFound
    case forbiddenAccess
    case requestLimit
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .writeError:
            return "Database write error occurred"
        case .readError:
            return "Database read error occurred"
        case .invalidAttributes:
            return "Attribute was invalid"
        case .attributesNotFound:
            return "Attribute was not found"
        case .forbiddenAccess:
            return "You cannot select this stage"
        case .requestLimit:
            return "Request exceeded the limit"
        case .custom(let error):
            return error
        }
    }
}

extension DatabaseError: Equatable {
    static func ==(lhs: DatabaseError, rhs: DatabaseError) -> Bool {
        switch (lhs, rhs) {
        case (.writeError, .writeError):
            return true
        case (.readError, .readError):
            return true
        case (.invalidAttributes, .invalidAttributes):
            return true
        case (.attributesNotFound, .attributesNotFound):
            return true
        case (.forbiddenAccess, .forbiddenAccess):
            return true
        case (.requestLimit, .requestLimit):
            return true
        case (let .custom(content1), let .custom(content2)):
            return content1 == content2
        default:
            return false
        }
    }
}
