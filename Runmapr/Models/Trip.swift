//
//  Trip.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//


import Foundation
import Firebase


struct Trip  {
    let date: String
    let tripId: String
    let duration: String
    let distance: String

    
    init?(tripId: String, tripData: Dictionary <String, Any>) {
        self.tripId = tripId
        

        if let duration = tripData["duration"] as? String {
            self.duration = duration } else { duration = "1" }
        if let distance = tripData["distance"] as? String {
            self.distance = distance } else { distance = "1" }
        if let date = tripData["date"] as? String {
            self.date = date } else { date = "0" }
    }
}
