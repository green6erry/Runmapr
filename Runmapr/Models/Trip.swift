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
    let date: String
    let tripId: String
    let duration: String
    let distance: String
//
//    var tripId: String = "0"
//    var duration: String = "0"
//    var distance: String = "0"
//    let date: Date
//    let dateString: String
//    let dateActual: Date
//    let distance: Double
//    let duration: Double
    
    init?(tripId: String, tripData: Dictionary <String, Any>) {
        self.tripId = tripId
        

        if let duration = tripData["duration"] as? String {
            self.duration = duration } else { duration = "1" }
        if let distance = tripData["distance"] as? String {
            self.distance = distance } else { distance = "1" }
        if let date = tripData["date"] as? String {
            self.date = date } else { date = "0" }
    
//    init?(tripId: String, tripData: Dictionary <String, Any>) {
//        self.tripId = tripId
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = tripData["date"] as? String
//
//        if let duration = tripData["duration"] as? String {
//            self.duration = duration } else { duration = "1" }
//        if let distance = tripData["distance"] as? String {
//            self.distance = distance } else { distance = "1" }
//
//        if let date = dateFormatter.date(from: dateString!) {
//            self.date = date } else { date = Date() }
    
        //
        //        guard let duration = tripData["duration"] as? String,
        //            let distance = tripData["distance"] as? String,
        ////            let dateString = tripData["date"] as? String,
        //            let date = dateFormatter.date(from: dateString!)
        //            else { return nil }
        ////
        //        self.duration = duration
        //        self.distance = distance
        //        self.date = date
        
        
    }
}
