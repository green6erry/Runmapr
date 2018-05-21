//
//  File.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/19/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import Foundation

class CoordsModel {
    var id: String?
    var longitude: String?
    var latitude: String?
    
    init(id: String?, longitude: String?, latitude: String?) {
        self.id = id
        self.longitude = longitude
        self.latitude = latitude
    }
}
