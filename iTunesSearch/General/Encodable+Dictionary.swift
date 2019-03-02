//
//  Encodable+Dictionary.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

extension Encodable {
    
    func toDictionary() throws -> [String: AnyObject]? {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(self)
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
    }
    
}
