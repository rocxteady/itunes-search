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
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
}
