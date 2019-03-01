//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

class NetworkResponse<T: Decodable>: Decodable {
    
    var resultCount: Int?
    
    var results: [T]?
    
}
