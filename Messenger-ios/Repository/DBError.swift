//
//  DBError.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/16/24.
//

import Foundation

// Firebase DB error type 
enum DBError: Error {
    case error(Error)
    case emptyValue
    case invalidatedType
}
