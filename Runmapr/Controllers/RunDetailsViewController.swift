
//  Runmapr
//
//  Created by Amanda Brown on 5/20/18.
//  Copyright © 2018 AGB Design. All rights reserved.
//

import UIKit
import MapKit

class RunDetailsViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
//    var selectedTrip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateLabel.text = "Date"
        self.durationLabel.text = "Duration"
        self.distanceLabel.text = "distanceLabel"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//extension RunDetailsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 1
//        guard let cell = tableView.cellForRow(at: indexPath) as? RunTableViewCell else { return }
//    }

//?
