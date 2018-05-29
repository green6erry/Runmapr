
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
    var polylines = [MKPolyline]()
    
    let sampleLocations = [
            CLLocationCoordinate2D(latitude: 32.7767, longitude: -96.798),
            CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167),
            CLLocationCoordinate2D(latitude: 42.2814, longitude: -83.7483)
            ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        durationLabel.text = "Duration: \(selectedTrip.duration)"
        distanceLabel.text = "Distance: \(selectedTrip.distance)"
        dateLabel.text = "Date: \(selectedTrip.date)"
        
        DatabaseService.shared.coordsReference.child("\(selectedTrip.tripId)").observe(DataEventType.value) { (snapshot) in
//            print("1snapshot \(snapshot)")
            guard let coordsSnapshot = CoordSnap(with: snapshot) else { return }
            self.coords = coordsSnapshot.coords
//            print("2coords count \(self.coords.count)")
//            print("3coords smaple \(self.coords[1].longitude)")
            
            for index in 1...self.coords.count - 1 {
                let longitude = Double(self.coords[index].longitude)
                let latitude = Double(self.coords[index].latitude)
                self.longitudes.append(longitude!)
                self.latitudes.append(latitude!)
                let newCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!))
                self.coordinates.insert(newCoordinate, at: 0)
                if self.coordinates.count > 2{
                    let coordTuple : [CLLocationCoordinate2D]
                    coordTuple = [self.coordinates[0], self.coordinates[1]]
                    self.mapView.add(MKPolyline(coordinates: coordTuple, count: 2))
                }
            }
            
            //coordinates have been added
//            print("4coordinates \(self.coordinates)")
//            print("5longitudes \(self.longitudes)")
//            print("6latitudes \(self.latitudes)")

            
            let region = self.mapRegion()
            self.mapView.setRegion(region!, animated: true)
            self.mapView.add(MKPolyline(coordinates: self.coordinates, count: self.coordinates.count))
//            self.mapView.add(MKPolyline(coordinates: self.coordinates, count: 4))
        }
    }
    
    
    private func mapRegion() -> MKCoordinateRegion? {
        
        let maxLat = self.latitudes.max()!
        let maxLong = self.longitudes.max()!
        let minLat = self.latitudes.min()!
        let minLong = self.longitudes.min()!
        
        let params: [String: Double] = ["maxLat" : self.latitudes.max()!,
                      "maxLong" : self.longitudes.max()!,
                      "minLat" : self.latitudes.min()!,
                      "minLong" : self.longitudes.min()!]
        
        print("8params \(params)")
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)

        return MKCoordinateRegion(center: center, span: span)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polylineRender.lineWidth = 5
        
        return polylineRender
    }

    
        
}
    


    
