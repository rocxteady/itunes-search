//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit
import RxSwift
class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let searchRequest = SearchRequest()
        searchRequest.parameters = ["term": "harry potter"]
        searchRequest.start()
            .subscribe(onNext: { (response) in
                print(response)
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: {
                print("Completed")
            }).disposed(by: self.disposeBag)
    }


}

