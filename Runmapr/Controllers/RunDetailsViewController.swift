
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class RunDetailsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedTrip: Trip!
    var coords = [Coord]()
    var coordinates = [CLLocationCoordinate2D]()
    var latitudes = [Double]()
    var longitudes = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        durationLabel.text = "Duration: \(selectedTrip.duration)"
        distanceLabel.text = "Distance: \(selectedTrip.distance)"
        dateLabel.text = "Date: \(selectedTrip.date)"
        
        //only set coordinates in loadMap() when Database Snapshot has finished
        loadData { (locations) in
            self.coordinates = locations
            self.loadMap()
        }
        
    }

    private func loadData(completion: @escaping (Array<CLLocationCoordinate2D>) -> Void) {
    
        DatabaseService.shared.coordsReference.child("\(selectedTrip.tripId)").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let coordsSnapshot = CoordSnap(with: snapshot) else { return }
            self.coords = coordsSnapshot.coords
            var locations = Array<CLLocationCoordinate2D>()
            
            
            for index in 1...self.coords.count - 1 {
                //convert strings to doubles
                let longitude = Double(self.coords[index].longitude)
                let latitude = Double(self.coords[index].latitude)
                //store numbers to array for calculations
                self.longitudes.append(longitude!)
                self.latitudes.append(latitude!)
                //create CLLocations with new numbers
                let newCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!))
                //append new CLLocations to array
                locations.append(newCoordinate)
                
            }
            //send out array of CLLocations upon completion
            completion(locations)
            
        })
    }
    
    
    private func mapRegion() -> MKCoordinateRegion? {

        let maxLat = self.latitudes.max()!
        let maxLong = self.longitudes.max()!
        let minLat = self.latitudes.min()!
        let minLong = self.longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
    
        return MKCoordinateRegion(center: center, span: span)
    }
    
    
    private func loadMap() {
        let locations = self.coordinates

        guard locations.count > 0,
            let region = mapRegion()
           else {
                let alert = UIAlertController(title: "Error",
                                              message: "Sorry, this run has no locations saved",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                
                return
        }
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.add(MKPolyline(coordinates: locations, count: locations.count))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polylineRender.lineWidth = 5
        return polylineRender
    }

}
    


    
