
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class RunDetailsViewController: UIViewController {

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
//        self.selectedTrip.date = (dateLabel.text as String?)!
        durationLabel.text = "Duration: \(selectedTrip.duration)"
        distanceLabel.text = "Distance: \(selectedTrip.distance)"
        dateLabel.text = "Date: \(selectedTrip.date)"
        
        DatabaseService.shared.coordsReference.child("\(selectedTrip.tripId)").observe(DataEventType.value) { (snapshot) in
            print(snapshot)
            guard let coordsSnapshot = CoordSnap(with: snapshot) else { return }
            self.coords = coordsSnapshot.coords
//            self.coordinates = self.coords.
            print("coords count \(self.coords.count)")
            print("coords smaple \(self.coords[1].longitude)")
            
            for index in 1...self.coords.count - 1 {
                let longitude = Double(self.coords[index].longitude)
                let latitude = Double(self.coords[index].latitude)
                self.longitudes.append(longitude!)
                self.latitudes.append(latitude!)
                let newCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude!), longitude: CLLocationDegrees(longitude!))
                self.coordinates.append(newCoordinate)
            }
            print("coordinates \(self.coordinates)")

            
            let region = self.mapRegion()
            self.mapView.setRegion(region!, animated: true)
            self.mapView.add(MKPolyline(coordinates: self.coordinates, count: self.coordinates.count))
            
            
        }

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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRender = MKPolylineRenderer(overlay: overlay)
        polylineRender.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polylineRender.lineWidth = 5
        
        return polylineRender
    }
    
    
        
}
    


    
