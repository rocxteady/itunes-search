//
//  ContentCell.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit
import Kingfisher

class ContentCell: UICollectionViewCell {
    
    static let identifier = "ContentCell"
    static let defaultHeight: CGFloat = 44.0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func load(content: Content) {
        self.nameLabel.text = content.trackName
        if let urlString = content.artworkUrl30 {
            self.imageView.kf.setImage(with: URL(string: urlString))
        }
        if content.isRead {
            self.contentView.backgroundColor = .lightGray
        }
        else {
            self.contentView.backgroundColor = .white
        }
    }
    
}
