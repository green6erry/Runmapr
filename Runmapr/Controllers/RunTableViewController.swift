//
//  RunTableViewController.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import Firebase

class RunTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //prototype cell called "Cell" - to make prettier after Core Location set up
    
    var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseService.shared.tripsReference.observe(DataEventType.value) { (snapshot) in
            print(snapshot)
            guard let tripsSnapshot = TripSnap(with: snapshot) else { return }
            self.trips = tripsSnapshot.trips
            self.tableView.reloadData()
        }
    }

    @IBAction func doneTapped(_ sender: Any) {
    }
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add run", message: "add sample data", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter duration"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "enter date"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "enter distance"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Post", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else { return }
            print(text)
//
            let dateString = String(describing: Date())
            let distance = 23
            let distanceString = String(distance)
            
            let parameters = ["duration":   text,
                              "distance":   distanceString,
                              "date":       dateString]
            
            DatabaseService.shared.tripsReference.childByAutoId().setValue(parameters)
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let trip = trips[indexPath.row]
        cell.textLabel?.text = String(describing: trip.date)
        cell.detailTextLabel?.text = trip.distance
        
        print(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

