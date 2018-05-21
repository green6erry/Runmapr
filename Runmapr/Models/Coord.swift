//
//  File.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/19/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import Foundation

struct Coord {
    var coordId: String?
    var longitude: Double?
    var latitude: Double?
    
    init?(coordId: String?, coordData: Dictionary <String, Any>){
        self.coordId = coordId
        
        guard let latitudeString = coordData["latitude"] as? String,
        let latitude = Double(latitudeString),
        let longitudeString = coordData["longitude"] as? String,
        let longitude = Double(longitudeString)
            else {return nil}
        
        self.latitude = latitude
        self.longitude = longitude

//
//            if let latitude = coordData["latitude"] as? String {
//                self.latitude = Int(latitude)
//            } else {
//                latitude = 1
//            }
//            if let longitude = coordData["longitude"] as? String {
//                self.longitude = Int(longitude)
//            } else {
//                longitude = 1
//            }
        
    }
}

