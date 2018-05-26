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
import SwiftyJSON

class NewRunViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var trips = [Trip]()
    var coords = [Coord]()
    var date : Date!
    var dateString: String!
    var runKey: String!
    var myCoordinates : CLLocationCoordinate2D!
    
    private let locationManager = LocationManager.shared
    private var locationList = [CLLocation]()
    
//    private var latitudes = [String]()
//    private var longitudes = [String]()
    
//    public ArrayList<Coord> coordsList = new ArrayList<>();
    var tripData : [String: String] = [:]
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
        self.runKey = DatabaseService.shared.tripsReference.childByAutoId().key
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        self.myCoordinates = location.coordinate
        

        
        print("myLocation.latitude \(location.coordinate.latitude)")
//        print("JSONmyLocation \(JSON(myLocation))")
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myCoordinates, span)
        mapView.setRegion(region, animated: true)
        


        if let lastLocation = locationList.last {
            let delta = location.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            let coordinates = [lastLocation.coordinate, self.myCoordinates!]
//            let coords = [myLocation.latitude, myLocation.longitude]
//            print("coordinates: \(coordinates.)")
            if self.stopButton.isHidden == false {
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
            }
        }
        locationList.append(location)
        
        self.mapView.showsUserLocation = true
        
        print("locationList \(locationList)")
        
    }
    
    @IBAction func exitTapped(_ sender: Any){
        locationManager.stopUpdatingLocation()
        dismiss(animated: true, completion: nil)
        DatabaseService.shared.coordsReference.child("\(self.runKey!)").setValue(nil)
        
    }

    
    @IBAction func startTapped(_ sender: Any) {

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.perSecond()
        }
        stopButton.isHidden = false
        startButton.isHidden = true
        closeButton.isHidden = true
        addCoord()
        startUpdatingLocation()
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
            self.dismiss(animated: true, completion: {
                DatabaseService.shared.coordsReference.child("\(self.runKey!)").setValue(nil)
            })
        }
        let save = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in
//           self.runKey = DatabaseService.shared.tripsReference.childByAutoId().key
            
            let key = self.runKey! as String
            //            print("runKey \(self.runKey)")
            
            self.tripData =  ["date": self.dateLabel.text! as String,
//                              "date": self.dateLabel.text! as String,
                         "duration": self.durationLabel.text! as String,
                         "distance" : self.distanceLabel.text! as String]
            

//            print("tripData \(self.tripData)")
            
            

            DatabaseService.shared.tripsReference.child("\(key)").setValue(self.tripData)
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
        let coordKey = DatabaseService.shared.coordsReference.child("\(self.runKey)").childByAutoId().key
        let coordData = [ "latitude": String(self.myCoordinates.latitude),
                          "longitude": String(self.myCoordinates.longitude)
        ]
        
        DatabaseService.shared.coordsReference.child("\(self.runKey!)").child("\(coordKey)").setValue(coordData)
        

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
