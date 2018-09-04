//
//  Realm+Utils.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 05/12/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RealmSwift
import RxSwift

extension Realm {
    
    func save(deputy:Deputy) -> Observable<Void> {
        
        return Observable<Void>.create { observer in
 
            do {
                try self.write {
                    self.add(deputy, update: true)
                    observer.onNext(())
                    observer.onCompleted()
                }
                
            } catch let error as NSError {
                observer.onError(error)
            }
            
            return Disposables.create()
        }.subscribeOn(MainScheduler.instance)
    }
}
