//
//  SHA256.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/15/24.
//

import Foundation
import CryptoKit

/**
 The sha256 function hashes a string using SHA-256 and returns the result as a hexadecimal string.
 */
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
