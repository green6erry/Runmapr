//
//  Trip.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import Foundation
import Firebase

struct Trip {
    let tripId: String
    let duration: String
    let distance: String
    let dateString: String
    let dateActual: Date
//    let distance: Double
//    let duration: Double
    
    init?(tripId: String, tripData: Dictionary <String, Any>) {
        self.tripId = tripId
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss +zzzz"
        
        if let duration = tripData["duration"] as? String {
            self.duration = duration
        } else {
            duration = "1"
        }
        if let distance = tripData["distance"] as? String {
            self.distance = distance
        } else {
            distance = "1"
        }
        if let dateString = tripData["dateSting"] as? String {
            self.dateString = dateString
        } else {
            dateString = "1"
        }
        if let dateActual = dateFormatter.date(from: dateString) {
            self.dateActual = dateActual
        } else {
            dateActual = Date()
        }
    }
}
