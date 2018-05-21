//
//  RunDetailsViewController.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import MapKit

class RunDetailsViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
