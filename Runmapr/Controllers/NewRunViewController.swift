 //
//  NewRunViewController.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import MapKit



class NewRunViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func startTapped(_ sender: Any) {
    }
    @IBAction func stopTapped(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
