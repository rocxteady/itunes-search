//
//  SearchResponse.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit

class SearchResponse: NetworkResponse<Content> {

}

extension SearchResponse: CustomStringConvertible {
    
    var description: String {
        return "Result Count: " + String(describing: self.resultCount) + "\n"
            + "Results: " + String(describing: self.results)
    }
    
}
