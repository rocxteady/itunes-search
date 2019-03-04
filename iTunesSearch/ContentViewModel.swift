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
    
    private var content: Content
    
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
    
    func read() {
        self.content.isRead = true
    }
    
}
