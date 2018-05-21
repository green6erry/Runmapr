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
    var longitude: String?
    var latitude: String?
    
    init?(coordId: String?, coordData: Dictionary <String, Any>){
        self.coordId = coordId
        
        guard let latitude = coordData["latitude"] as? String,
        let longitude = coordData["longitude"] as? String
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

