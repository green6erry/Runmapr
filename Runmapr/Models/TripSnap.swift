//
//  TripSnap.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/21/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import Foundation
import Firebase

struct TripSnap {
    var trips : [Trip]
    
    init?(with snapshot: DataSnapshot) {
        self.trips = [Trip]()
        //we went to make sure it's a dictionary btcause we can't iterate through a value
        guard let snapDictionary = snapshot.value as? [String: [String: Any]] else {return nil}
        //for each value in the dictionary, we'll create an object. It should also be failable because we made Trip is a failable initializer
        for snap in snapDictionary {
            guard let trip = Trip(tripId: snap.key, tripData: snap.value) else { continue }
            trips.append(trip)
        }
    }
}
