//
//  ContentViewModel.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 4.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

class ContentViewModel {
    
    var content: Content
    
    init(content: Content) {
        self.content = content
    }
    
}


extension ContentViewModel {
    
    func load(view: ContentView) {
        view.contentArtistNameLabel.text = content.artistName
        view.contentTrackNameLabel.text = content.trackName
        if let urlString = content.artworkUrl100 {
            view.contentImageView.kf.setImage(with: URL(string: urlString))
        }
    }
    
}

extension ContentViewModel {
    
    func read() throws {
        self.content.isRead = true
        var fileContent = ContentFileManager.sharedManager.getContent(by: self.content.identity)
        if fileContent != nil {
            fileContent!.isRead = true
        }
        else {
            fileContent = FileContent(identity: self.content.identity, isRead: true)
        }
        try ContentFileManager.sharedManager.write(content: fileContent!)
    }
    
    func delete() throws {
        var fileContent = ContentFileManager.sharedManager.getContent(by: self.content.identity)
        if fileContent != nil {
            fileContent!.isDeleted = true
        }
        else {
            fileContent = FileContent(identity: self.content.identity, isRead: true)
        }
        try ContentFileManager.sharedManager.write(content: fileContent!)
    }
    
}
