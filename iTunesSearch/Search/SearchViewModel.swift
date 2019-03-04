//
//  SearchViewModel.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation
import RxSwift

class SearchViewModel {
    
    let contentSections = Variable<[ContentSection]>([ContentSection]())
    
    var term = Variable<String>("")
    
    var contentType = Variable<ContentType>(.all)
    
    private let request = SearchRequest()
    
    private var disposable: Disposable?
    
    private var disposeBag = DisposeBag()
    
    init() {
        self.request.parameters = SearchParams()
        self.term.asObservable().subscribe(onNext: { (term) in
            self.request.parameters?.term = term
            self.search()
        }).disposed(by: self.disposeBag)
        self.contentType.asObservable().distinctUntilChanged().subscribe(onNext: { (contentType) in
            self.request.parameters?.media = contentType
            self.search()
        }).disposed(by: self.disposeBag)
    }
    
    private func search() {
        self.disposable = self.request.start()
            .subscribe(onNext: { [weak self] (response) in
                self?.contentSections.value = [ContentSection(header: self?.contentType.value.rawValue ?? ContentType.all.rawValue, items: response.results ?? [Content]())]
            }, onError: { [weak self] (error) in
                self?.disposable?.dispose()
            }, onCompleted: { [weak self] in
                self?.disposable?.dispose()
            })
    }
    
}
