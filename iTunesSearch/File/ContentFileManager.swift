//
//  ContentFileManager.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 4.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

class ContentFileManager {
    
    static let sharedManager = ContentFileManager()
    
    private static let fileName = "contents"
    
    private let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private var contents: [FileContent]?
    
    init() {
        do {
            try self.read()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getContent(by identity: String) -> FileContent? {
        return self.contents?.filter({return $0.identity == identity}).first
    }
    
    func write(content: FileContent) throws {
        if contents == nil {
            contents = [FileContent]()
        }
        contents!.uniqueAppend(newElement: content)
        let data = try JSONEncoder().encode(contents!)
        try write(data: data, with: ContentFileManager.fileName)
    }
    
    @discardableResult
    func read() throws -> [FileContent]? {
        if let data = try read(from: ContentFileManager.fileName) {
            self.contents = try [FileContent](data: data)
        }
        return self.contents
    }
    
}

//MARK: File Operations
extension ContentFileManager {
    
    private func write(data: Data, with key: String) throws {
        if let fileURL = dir?.appendingPathComponent(key) {
            try data.write(to: fileURL)
        }
        else {
            throw ErrorHelper.crateError(type: .fileError)
        }
    }
    
    private func read(from key: String) throws -> Data? {
        if let fileURL = dir?.appendingPathComponent(key) {
            return try Data(contentsOf: fileURL)
        }
        throw ErrorHelper.crateError(type: .fileError)
    }
    
}
