//
//  RealApi.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxAlamofire
import RxSwift
import Alamofire

class RealApi: Api {
    
    func get(url: String, queryParameters:[String:Any]) ->  Observable<Any> {
        
        log.debug("GET : \(url)")
        log.debug("Parameters : \(queryParameters)")
        
        return Observable<Any>.create({ observer in
            
            let observable = self.request(method: .get, url: url, parameters: queryParameters, encoding: URLEncoding.queryString)
                .subscribe(onNext: { json in
                    log.debug("\(url) : Success")
                    observer.onNext(json)
                    observer.onCompleted()
                }, onError: { error in
                    log.error("API call error : \(error)")
                    observer.onError(error)
                })
            
            return Disposables.create([observable])
        }).observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
    }
    
    func post(url: String, bodyParameters:[String:Any]) ->  Observable<Any> {
        
        log.debug("POST : \(url)")
        log.debug("Parameters : \(bodyParameters)")
        
        return Observable<Any>.create({ observer in
            
            let observable = self.request(method: .post, url: url, parameters: bodyParameters, encoding: URLEncoding.httpBody)
                .subscribe(onNext: { json in
                    log.debug("\(url) : Success")
                    observer.onNext(json)
                    observer.onCompleted()
                }, onError: { error in
                    log.error("API call error : \(error)")
                    observer.onError(error)
                })
            
            return Disposables.create([observable])
        })
        
    }
    
    //MARK: - Private helpers
    
    private func request(method: HTTPMethod, url: String, parameters:[String: Any], encoding: ParameterEncoding) -> Observable<Any> {
        
        return RxAlamofire.request(method, url, parameters: parameters, encoding: encoding, headers: nil)
            .flatMap { request in
                return request.validate(statusCode: 200..<300).rx.json()
        }
    }
    
    
}
