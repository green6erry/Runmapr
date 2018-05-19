//
//  ViewController.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/17/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopRunButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapContainerView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    let manager = CLLocationManager()
    var locationList = [CLLocation]()
    var coordsList = [CLLocationCoordinate2D]()
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        mapView.delegate = self
    
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation = location.coordinate
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        
        if let lastLocation = locationList.last {
            let delta = location.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            let coordinates = [lastLocation.coordinate, myLocation]
            mapView.add(MKPolyline(coordinates: coordinates, count: 2))
        }
        
        self.mapView.showsUserLocation = true
    
        locationList.append(location)
        
    }

    
    
    @IBAction func deleteButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stopRun(_ sender: Any) {
        let alert = UIAlertController(title: "Run Options", message: "Would you like to save this run?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive)  { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let save = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in
            let text = "text"
            print(text)
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        alert.addAction(save)
        present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polylineRender.lineWidth = 5
        
        return polylineRender
    }
}


    
