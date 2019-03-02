//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UICollectionViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.dataSource = nil
        self.collectionView.delegate = nil
        setupRx()
        search()
    }
    
    private func setupRx() {
        self.viewModel.contents.asObservable().bind(to: self.collectionView.rx.items(cellIdentifier: ContentCell.identifier, cellType: ContentCell.self)) { (index, content, cell) in
            cell.load(content: content)
        }.disposed(by: self.disposeBag)
        self.collectionView.rx.setDelegate(self)
        .disposed(by: self.disposeBag)
    }

    private func search() {
        self.viewModel.search(term: "harry potter")
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            return CGSize(width: (collectionView.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing)/2.0, height: ContentCell.defaultHeight)
        }
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        return CGSize(width: (collectionView.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right), height: ContentCell.defaultHeight)

    }
    
}

//MARK: UIContentContainer
extension SearchViewController {
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
