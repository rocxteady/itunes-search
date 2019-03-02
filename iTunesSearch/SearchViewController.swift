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
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    private let searchBar = UISearchBar(frame: .zero)
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.searchBar.showsCancelButton = true
        self.navigationItem.titleView = self.searchBar
        self.collectionView.dataSource = nil
        self.collectionView.delegate = nil
        setupRx()
    }
    
    private func setupRx() {
        self.searchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .bind(to: self.viewModel.term)
        .disposed(by: self.disposeBag)
        self.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
                self.searchBar.text = nil
                self.searchBar.resignFirstResponder()
            }).disposed(by: self.disposeBag)
        self.viewModel.contents.asObservable().bind(to: self.collectionView.rx.items(cellIdentifier: ContentCell.identifier, cellType: ContentCell.self)) { (index, content, cell) in
            cell.load(content: content)
        }.disposed(by: self.disposeBag)
        self.collectionView.rx.setDelegate(self)
        .disposed(by: self.disposeBag)
        self.collectionView.rx.didScroll.subscribe(onNext: {
            self.searchBar.resignFirstResponder()
        }).disposed(by: self.disposeBag)
        self.collectionView.rx.itemSelected.subscribe(onNext: { _ in
            self.searchBar.resignFirstResponder()
        }).disposed(by: self.disposeBag)
        self.filterButton.rx.tap.subscribe(onNext: {
            let alertController = UIAlertController(title: NSLocalizedString("Content Types", comment: ""), message: NSLocalizedString("Pick Please", comment: ""), preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            for contentType in ContentType.allTypes() {
                alertController.addAction(UIAlertAction(title: contentType.description, style: .default, handler: { (action) in
                    self.viewModel.contentType.value = contentType
                }))
            }
            self.present(alertController, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
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
