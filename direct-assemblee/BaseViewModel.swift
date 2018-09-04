//
//  BaseViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 13/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift

class BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    deinit {
        log.debug(type(of: self))
    }
}
