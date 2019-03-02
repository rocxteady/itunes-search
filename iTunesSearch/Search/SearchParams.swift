//
//  SearchParams.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

struct SearchParams: Encodable {
    
    var limit = 200
    
    var term = ""
    
}

extension SearchParams {
    
    init(term: String) {
        self.term = term
    }
    
}
