//
//  SearchRequest.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit

class SearchRequest: NetworkRequest<SearchResponse, SearchParams> {
    
    override init() {
        super.init()
        self.path = "/search"
    }
    
}
