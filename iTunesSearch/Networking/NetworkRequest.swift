//
//  NetworkRequest.swift
//  iTunesSearch
//
//  Created by Ulaş Sancak on 1.03.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkRequestProtocol {
    
    var path: String {get}
    
    var parameters: [String: Any]? {get}
    
}

//T for response object model
class NetworkRequest<T: Decodable>: NetworkRequestProtocol {
    
    private var httpMethod: HTTPMethod = .get
    
    var path: String = ""
    
    var parameters: [String : Any]?
    
    var currentRequest: DataRequest?
    
    private(set) var currentTask: URLSessionTask?
    
    func start() -> Observable<T> {
        let fullURLString = createURLString()
        self.currentRequest = AF.request(fullURLString, method: self.httpMethod, parameters: self.parameters)
        return Observable<T>.create({ [weak self] (observer) -> Disposable in
            self?.currentRequest?.responseData { response in
                self?.end()
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let t = try T(data: data)
                            observer.onNext(t)
                        } catch let error {
                            observer.onError(error)
                        }
                    }
                    else {
                        let error = ErrorHelper.crateError(type: .noData)
                        observer.onError(error)
                    }
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        })
    }
    
    func end() {
        if let currentRequest = self.currentRequest, let currentTask = currentRequest.task {
            if currentTask.state == .running || currentTask.state == .suspended {
                currentTask.cancel()
            }
            self.currentRequest = nil
        }
    }
    
}

// MARK: - NetworkRequest Creating URL String
extension NetworkRequest {
    
    func createURLString() -> String {
        return Configs.Network.baseURL+self.path
    }
    
}
