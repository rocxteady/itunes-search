//
//  ContentSection.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 2.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import RxDataSources

struct ContentSection {
    var header: String
    var items: [Content]
}

extension ContentSection: SectionModelType {
    typealias Item = Content
    
    init(original: ContentSection, items: [Item]) {
        self = original
        self.items = items
    }
}
