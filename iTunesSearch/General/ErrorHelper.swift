//
//  ErrorHelper.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

enum ErrorType: Int {
    
    case noData = 0
    
    var description: String {
        get {
            switch self {
            case .noData:
                return NSLocalizedString("No data available currently.", comment: "")
            }
        }
    }
    
}

struct ErrorHelper {
    
    private static let domain = Bundle.main.bundleIdentifier! + ".error"
    
    static func crateError(type: ErrorType) -> Error {
        return NSError(domain: domain, code: type.rawValue, userInfo: [NSLocalizedDescriptionKey: type.description])
    }
}
