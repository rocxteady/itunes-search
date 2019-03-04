//
//  FileContent.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 4.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

extension Array where Element == FileContent {
    
    mutating func uniqueAppend(newElement: Element) {
        if let index = self.index(of: newElement) {
            let element = self[index]
            element.isRead = newElement.isRead
            element.isDeleted = newElement.isDeleted
        }
        else {
            self.append(newElement)
        }
    }
    
}

class FileContent: Codable {
    
    var identity: String
    
    var isRead = false
    
    var isDeleted = false
    
    init(identity: String) {
        self.identity = identity
    }
    
}

extension FileContent {
    
    convenience init(identity: String, isRead: Bool = false, isDeleted: Bool = false) {
        self.init(identity: identity)
        self.isRead = isRead
        self.isDeleted = isDeleted
    }
    
}

extension FileContent: Equatable {
    
    static func == (lhs: FileContent, rhs: FileContent) -> Bool {
        return lhs.identity == rhs.identity
    }
    
}
