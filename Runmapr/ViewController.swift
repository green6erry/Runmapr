//
//  ViewController.swift
//  Runmapr
//
//  Created by Amanda Brown on 5/17/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopRunButton: UIButton!
    @IBOutlet weak var locationMarker: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView? = UITableView()
        tableView?.dataSource = self
        tableView?.delegate = self
//        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
   
    @IBAction func historyButton(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    tablVi
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = tableView.dequeueReusableCell(withIdentifier: "tableRow", for: indexPath)
        entry.textLabel?.text = "Hello World"
        let dateString = Date().toString(dateFormat: "MMM/dd/yyyy")
        let listIndex = entry.contentView.viewWithTag(10) as! UILabel?
        listIndex?.text = "\(indexPath.row + 1)"
        entry.detailTextLabel?.text = dateString
        print("table connectd?")
        return entry
        
    }
   

}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
    
