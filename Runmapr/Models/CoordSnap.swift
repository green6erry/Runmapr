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
        
        guard let snapCoordDictionary = snapshot.value as? [String: [String: Any]] else {return nil}

        for snap in snapCoordDictionary {
            guard let coord = Coord(coordId: snap.key, coordData: snap.value) else { continue }
            coords.append(coord)
        }
    }
}
