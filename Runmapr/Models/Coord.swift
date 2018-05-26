//
//  File.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/19/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import Foundation

struct Coord {

    let coordId: String
    let longitude: String
    let latitude: String
    
    
    
    init?(coordId: String, coordData: Dictionary <String, Any>) {
        self.coordId = coordId
        
        
        if let longitude = coordData["longitude"] as? String {
            self.longitude = longitude } else { longitude = "1" }
        if let latitude = coordData["latitude"] as? String {
            self.latitude = latitude } else { latitude = "1" }
    }
    
}

