//
//  Content.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

enum ContentType: String, Encodable {
    
    case movie = "movie"
    case podcast = "podcast"
    case music = "music"
    case all = "all"
    
    var description: String {
        return self.rawValue.capitalized
    }
    
    static func allTypes() -> [ContentType] {
        return [ContentType.movie, ContentType.podcast, ContentType.music, ContentType.all]
    }
    
}

struct Content: Decodable {
    
    let wrapperType: String?
    let kind: String?
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: Date?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?

}

extension Content: Equatable {
    
    static func == (lhs: Content, rhs: Content) -> Bool {
        return lhs.trackId == rhs.trackId
    }
    
}

extension Content: CustomStringConvertible {
    
    var description: String {
        return "Artist ID: " + String(describing: self.artistId) + "\n" +
        "Track Name: " + String(describing: self.trackName)
    }
    
}
