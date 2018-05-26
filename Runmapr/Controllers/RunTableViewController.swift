//
//  RunTableViewController.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class RunTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    
    var trips = [Trip]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300

        
     
        
        
        
        DatabaseService.shared.tripsReference.observe(DataEventType.value) { (snapshot) in
            print(snapshot)
            guard let tripsSnapshot = TripSnap(with: snapshot) else { return }
            self.trips = tripsSnapshot.trips
            self.tableView.reloadData()
        }
        
    }

    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RunTableViewCell
        let trip : Trip
        trip = trips[indexPath.row]
        cell.dateLabel.text = String(describing: trip.date)
        cell.distanceLabel.text = trip.distance
        cell.durationLabel.text = trip.duration
        print("trip.tripId \(trip.tripId)")
        cell.indexLabel.text = "No. \(indexPath.row)"
        
        print(cell)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailView = segue.destination as? RunDetailsViewController,
            let indexPath = tableView.indexPathForSelectedRow {
                detailView.selectedTrip = trips[indexPath.row]
            }
        }
    
//        print("UIStoryboardSegue")
//        print ("duration \(self.selectedTrip!.duration)")

//        detailView.dateValue =
//        detailView.distanceValue = selectedTrip.distance
//        detailView.durationValue = selectedTrip.duration
        
        
        
//        if let destination = segue.destination as? RunDetailsViewController,
//            let indexPath = tableView.indexPathForSelectedRow {
//            destination.selectedTrip = trips[indexPath.row]
//        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("didSelectRow")

        
//        let detailView = storyboard?.instantiateViewController(withIdentifier: "RunDetailsViewController") as? RunDetailsViewController
//        //        let rtrip = trips[indexPath.row]
//        //        detailView?.distanceLabel!.text = rtrip.distance
//
//        self.navigationController?.pushViewController(detailView!, animated: true)
        
        
        
//        var self.selectedTrip = trips[indexPath.row]
//        let trip : Trip!
//        _ = trips[indexPath.row]
//        print(trip: )
        
//        detailView.distanceLabel?.text = trip.distance
//        detailView.distanceLabel!.text = "butt"
//        detailView?.durationLabel.text = trip.duration
//        detailView?.dateLabel.text = String(describing: trip.date)
        
//        self.navigationController?.pushViewController((detailView)!, animated: true)
    }
    
//    @IBAction func addTapped(_ sender: Any) {
//        let alert = UIAlertController(title: "Add run", message: "add sample data", preferredStyle: .alert)
//
//        alert.addTextField { (textField) in
//            textField.placeholder = "enter duration"
//        }
//        alert.addTextField { (textField) in
//            textField.placeholder = "enter date"
//        }
//        alert.addTextField { (textField) in
//            textField.placeholder = "enter distance"
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let post = UIAlertAction(title: "Post", style: .default) { _ in
//            guard let text = alert.textFields?.description else { return }
////            guard let text = alert.textFields?.first?.text else { return }
//            print(text)
//
//            let dateString = String(describing: Date())
//            let distance = 23
//            let distanceString = String(distance)
//
//            let parameters = ["duration":   text,
//                              "distance":   distanceString,
//                              "date":       dateString]
//            let key = DatabaseService.shared.tripsReference.childByAutoId().key as String?
//
//            let newTrip = Trip(tripId: key!, tripData: parameters)
//
//            DatabaseService.shared.tripsReference.childByAutoId().setValue(newTrip)
//            self.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(cancel)
//        alert.addAction(post)
//        present(alert, animated: true) {
//            print(alert.textFields as Any)
//        }
//
//    }

}


