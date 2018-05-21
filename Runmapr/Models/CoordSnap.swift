//
//  CoordSnap.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/21/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import Foundation
import Firebase

struct CoordSnap {
    var coords : [Coord]
    
    init?(with snapshot: DataSnapshot) {
        self.coords = [Coord]()
        //we went to make sure it's a dictionary btcause we can't iterate through a value
        guard let snapDictionary = snapshot.value as? [String: [String: Any]] else {return nil}
        //for each value in the dictionary, we'll create an object. It should also be failable because we made Trip is a failable initializer
        for snap in snapDictionary {
            guard let coord = Coord(coordId: snap.key, coordData: snap.value) else { continue }
            coords.append(coord)
        }
    }
}
