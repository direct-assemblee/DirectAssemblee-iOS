//
//  DeclarationResponseHandler.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 06/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import SwiftyJSON

struct DeclarationResponseHandler {
    
    static func declarations(fromJson json:Any) -> [Declaration] {
        
        var declarations = [Declaration]()
        
        guard let declarationsJsonArray = json as? [Any] else {
            return declarations
        }
        
        for declarationsJson in declarationsJsonArray {
            
            if let declaration = DeclarationResponseHandler.declaration(fromJson: declarationsJson) {
                declarations.append(declaration)
            }
        }
        
        return declarations
    }
    
    static func declaration(fromJson json:Any) -> Declaration? {
        
        let declarationJsonDictionary = JSON(json)
        
        guard let title = declarationJsonDictionary["title"].string,
            let date = Date.from(string: declarationJsonDictionary["date"].string ?? ""),
            let url = declarationJsonDictionary["url"].string else {
                
                return nil
        }
        
        let declaration = Declaration()
        declaration.title = title
        declaration.date = date
        declaration.url = url
        
        return declaration
    }
}
