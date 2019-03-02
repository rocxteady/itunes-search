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
    
    associatedtype P
    
    var path: String {get}
    
    var parameters: P? {get}
    
}

//T for response object model
//P for parameters object model
class NetworkRequest<T: Decodable, P: Encodable>: NetworkRequestProtocol {
    
    private var httpMethod: HTTPMethod = .get
    
    var path: String = ""
    
    var parameters: P?
    
    var currentRequest: DataRequest?
    
    private(set) var currentTask: URLSessionTask?
    
    func start() -> Observable<T> {
        return Observable<T>.create({ (observer) -> Disposable in
            let fullURLString = self.createURLString()
            var params: [String: AnyObject]?
            if let parameters = self.parameters {
                do {
                    params = try parameters.toDictionary()
                } catch let error {
                    print(error.localizedDescription)
                    let error = ErrorHelper.crateError(type: .noData)
                    observer.onError(error)
                    return Disposables.create()
                }
            }
            self.currentRequest = AF.request(fullURLString, method: self.httpMethod, parameters: params)
            self.currentRequest?.responseData { response in
                self.end()
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let t = try T(data: data)
                            observer.onNext(t)
                            observer.onCompleted()
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
