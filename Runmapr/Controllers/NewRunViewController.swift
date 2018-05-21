 //
//  NewRunViewController.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase



class NewRunViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = LocationManager.shared
    private var locationList = [CLLocation]()
    private var coordsList = [CLLocationCoordinate2D]()
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        stopButton.isEnabled = false
        closeButton.isEnabled = false
        updateDisplay()
        
        mapView.delegate = self
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let date = Date()
        
        let dateString = dateFormatter.string(from: date)
//        print(dateFormatter.string(from: date))
        
        dateLabel.text = dateString
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
            if self.stopButton.isEnabled == true {
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
            }
        }
        
        self.mapView.showsUserLocation = true
        locationList.append(location)
        
    }

    
    @IBAction func startTapped(_ sender: Any) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.perSecond()
        }
        stopButton.isEnabled = true
        startButton.isEnabled = false
        closeButton.isEnabled = false
        startUpdatingLocation()
    }
    @IBAction func stopTapped(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        startButton.isEnabled = true
        closeButton.isEnabled = true
        timer?.invalidate()
//
    }
    @IBAction func closeTapped(_ sender: Any) {
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
    
    func perSecond() {
        seconds += 1
        updateDisplay()
    }
     func updateDisplay() {
        distanceLabel.text = formatDistance(distance)
        durationLabel.text = formatTime(seconds)
    }
    
    func startUpdatingLocation(){
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        print("started running")
    }

    
    func formatDistance(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        return formatter.string(from: distance)
    }
    
    func formatTime(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polylineRender.lineWidth = 5
        
        return polylineRender
    }
    


}
