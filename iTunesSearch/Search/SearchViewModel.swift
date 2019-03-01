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
    
    let contents = Variable<[Content]>([Content]())
    
    private let request = SearchRequest()
    
    private var disposable: Disposable?
    
    func search() {
       self.disposable = self.request.start()
            .subscribe(onNext: { [weak self] (response) in
                self?.contents.value = response.results ?? [Content]()
            }, onError: { [weak self] (error) in                
                self?.disposable?.dispose()
            }, onCompleted: { [weak self] in
                self?.disposable?.dispose()
            })
    }
    
}
