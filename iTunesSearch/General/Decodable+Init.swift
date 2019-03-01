//
//  Decodable+Init.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

extension Decodable {
    
    init(data: Data) throws {
        let jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        self = try jsonDecoder.decode(Self.self, from: data)
    }
    
}
