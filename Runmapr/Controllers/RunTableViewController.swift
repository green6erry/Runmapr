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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("didSelectRow")
    }
}


