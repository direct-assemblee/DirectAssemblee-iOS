//
//  DeputyDeclarationViewModel.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 16/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import RxSwift


class DeputyDeclarationViewModel: DeputyDetailTitleAndValueViewModel {
    
    var url:String!
    
    convenience init(declaration: Declaration) {
        self.init(titleText: declaration.title, valueText: "\(R.string.localizable.declarations_of_interest_delivered_on()) \(declaration.date.toString(withFormat: "dd/MM/yyyy"))")
        self.url = declaration.url
        self.isSelectable = true
    }
}
