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
import RxDataSources

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
        self.collectionView.register(UINib(nibName: ContentHeaderView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ContentHeaderView.identifier)
        setupRx()
    }
    
    private func setupRx() {
        
        let datasource = RxCollectionViewSectionedReloadDataSource<ContentSection>(configureCell: { (datasource, collectionView, indexPath, content) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.load(content: content)
            return cell
        }, configureSupplementaryView: { (datasource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let contentHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ContentHeaderView.identifier, for: indexPath) as! ContentHeaderView
            let contentSection = self.viewModel.contentSections.value[indexPath.section]
            contentHeaderView.titleLabel.text = NSLocalizedString("Content Type: ", comment: "") + contentSection.header.capitalized
            return contentHeaderView
        })
        
        self.searchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .bind(to: self.viewModel.term)
        .disposed(by: self.disposeBag)
        
        self.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { () in
                self.searchBar.text = nil
                self.searchBar.resignFirstResponder()
            }).disposed(by: self.disposeBag)
        
        self.viewModel.contentSections.asObservable().bind(to: self.collectionView.rx.items(dataSource: datasource))
        .disposed(by: self.disposeBag)
        
        self.viewModel.errorPublishSubject.asObserver()
            .subscribe(onNext: { [weak self] (error) in
                self?.showError(error: error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        .disposed(by: self.disposeBag)
        
        self.viewModel.startedPublishSubject.asObserver()
            .subscribe(onNext: { () in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.completedPublishSubject.asObserver()
            .subscribe(onNext: { () in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        .disposed(by: self.disposeBag)
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
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

extension SearchViewController {
    
    private func showError(error: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
