//
//  DatabaseService.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/21/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import Foundation
import Firebase

class DatabaseService {
    static let shared = DatabaseService()
    private init() {}
    
//    let ref = Database.database().reference()
    let tripsReference = Database.database().reference().child("trips")
}

//DatabaseService.shared.Database.database().reference().child("runs").child
