//
//  PlacesResponseHandler.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 26/06/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import SwiftyJSON
import GEOSwift
import CoreLocation

struct PlacesResponseHandler {
    
    static func places(fromJson json:Any) -> [Place] {
        
        guard let jsonPlaces = json as? [String: Any],
            let features = Features.fromGeoJSONDictionary(jsonPlaces as Dictionary<String, AnyObject>) else {
            return []
        }
        
        var places = [Place]()
        
        for feature in features {
            
            if let name = feature.properties?["name"] as? String,
                let postCode = feature.properties?["postcode"] as? String,
                let city = feature.properties?["city"] as? String,
                let point = feature.geometries?[0] as? Waypoint {
                
                var coordinates = CLLocationCoordinate2D()
                coordinates.latitude = point.coordinate.y
                coordinates.longitude = point.coordinate.x
                
                let place = Place(name: name, postCode: postCode, city: city, coordinates: coordinates)
                
                places.append(place)
            }
            
        }
    
        return places
    }
    
}
