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
    
    let term = Variable<String>("")
    
    let contentType = Variable<ContentType>(.all)
    
    let errorPublishSubject = PublishSubject<String>()
    
    let startedPublishSubject = PublishSubject<Void>()
    
    let completedPublishSubject = PublishSubject<Void>()
    
    private let request = SearchRequest()
    
    private var disposable: Disposable?
    
    private var disposeBag = DisposeBag()
    
    //Control for if user starts typing while searching
    private var shouldContinueSearch = false
    
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
        //Stop if a search request is going on
        self.request.end()
        
        self.startedPublishSubject.onNext(())
        self.shouldContinueSearch = true
        self.disposable = self.request.start()
            .subscribe(onNext: { [weak self] (response) in
                let results = response.results?.filter({ (content) -> Bool in
                    if let fileContent = ContentFileManager.sharedManager.getContent(by: content.identity) {
                        return !fileContent.isDeleted
                    }
                    return true
                }).map({ (content) -> Content in
                    if let fileContent = ContentFileManager.sharedManager.getContent(by: content.identity) {
                        content.isRead = fileContent.isRead
                    }
                    return content
                })
                self?.contentSections.value = [ContentSection(header: self?.contentType.value.rawValue ?? ContentType.all.rawValue, items: results ?? [Content]())]
            }, onError: { [weak self] (error) in
                if let error = error as NSError? {
                    self?.disposable?.dispose()
                    
                    //Ignore error if request is cancelled while typing
                    if error.code != NSURLErrorCancelled {
                        self?.shouldContinueSearch = false
                        self?.errorPublishSubject.onNext(error.localizedDescription)
                    }
                    else {
                        //Start searching because disposable is disposed because the previous request is cancelled
                        if self?.shouldContinueSearch ?? false {
                            self?.shouldContinueSearch = false
                            self?.search()
                        }
                    }
                }
                else {
                    self?.shouldContinueSearch = false
                    self?.errorPublishSubject.onNext(error.localizedDescription)
                    self?.disposable?.dispose()
                }
            }, onCompleted: { [weak self] in
                self?.shouldContinueSearch = false
                self?.completedPublishSubject.onNext(())
                self?.disposable?.dispose()
            })
    }
    
    func delete(content: Content) {
        if var contentSection = self.contentSections.value.first {
            if let index = contentSection.items.firstIndex(of: content) {
                contentSection.items.remove(at: index)
            }
        }
    }
    
}
