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
    
    
    var trips = [Trip]()
    var date : Date!
    var dateString: String!
    var runKey: String!
//    var coordDict: [String: String] = [:]
//    var cLatitude: String!
//    var cLongitude: String!
    
    private let locationManager = LocationManager.shared
    private var locationList = [CLLocation]()
    
    private var latitudes = [String]()
    private var longitudes = [String]()
    
//    public ArrayList<Coord> coordsList = new ArrayList<>();
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
        stopButton.isHidden = true
        closeButton.isHidden = true
        updateLabels()
        
        mapView.delegate = self
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        self.date = Date()
        let dateString = dateFormatter.string(from: self.date)
        print(dateFormatter.string(from: date))
        
        dateLabel.text = dateString
        print("dateString \(dateString)")
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
//            let coords = [myLocation.latitude, myLocation.longitude]
//            print("coordinates: \(coordinates.)")
            if self.stopButton.isHidden == false {
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
            }
        }
        
        self.mapView.showsUserLocation = true
        locationList.append(location)
        
    }
    
    @IBAction func exitTapped(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func startTapped(_ sender: Any) {

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.perSecond()
        }
        stopButton.isHidden = false
        startButton.isHidden = true
        closeButton.isHidden = true

        startUpdatingLocation()
        self.runKey = DatabaseService.shared.tripsReference.childByAutoId().key as String?
        print("runKey \(self.runKey!)")
    }
    @IBAction func stopTapped(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        startButton.isHidden = true
        closeButton.isHidden = false
        stopButton.isHidden = true

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
           self.runKey = DatabaseService.shared.tripsReference.childByAutoId().key
            
            let key = self.runKey! as String
            //            print("runKey \(self.runKey)")
            
            let trip =  ["date": self.dateLabel.text! as String,
                         "duration": self.durationLabel.text! as String,
                         "distance" : self.distanceLabel.text! as String]
            //                        "latitudes": self.latitudes as Array,
            //                        "longitudes": self.longitudes as Array
            
            //            print("trip: \(trip)")
            
            
            
            DatabaseService.shared.tripsReference.child("\(key)").setValue(trip)
            //            DatabaseService.shared.tripsReference.childByAutoId().setValue(trip)
            self.dismiss(animated: true, completion: nil)

        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        alert.addAction(save)
        present(alert, animated: true, completion: nil)
    }
    
    func perSecond() {
        seconds += 1
        updateLabels()
        addCoord()
    }
     func updateLabels() {
        distanceLabel.text = formatDistance(distance)
        durationLabel.text = formatTime(seconds)
    }

    
    func addCoord() {
        let cLongitude = String(describing: locationList[0].coordinate.longitude) as String?
        let cLatitude = String(describing: locationList[0].coordinate.latitude) as String?
        
//        let coordKey = DatabaseService.shared.tripsReference.child("\(self.runKey!)/coords").childByAutoId().key
        
        longitudes.append(cLongitude!)
        latitudes.append(cLatitude!)
        
//        let coord = ["latitude": cLatitude,
//                     "cLongitude": cLongitude,
//                     "coordId": coordKey]
//        let coordData = ["latitude": cLatitude,
//                     "longitude": cLongitude]
//
//
//        self.coordsList.append(Coord(coordId: coordKey, coordData: coordData)!)
//        print(self.coordsList)
        
//        Dictionary<String, Any>
        
//        DatabaseService.shared.tripsReference.child("\(self.runKey)").child("coords").child("\(coordKey)").setValue(Coord(coordId: coordKey, coordData: coordData))
        

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
