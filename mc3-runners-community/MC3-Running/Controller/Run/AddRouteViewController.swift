//
//  AddRouteViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 20/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddRouteViewController: UIViewController {
    var LocationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D?
    @IBOutlet weak var currentLoc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentLocation)
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = true
    }

}
extension AddRouteViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastlocation = locations.first else {return}
        currentLocation = lastlocation.coordinate
    }
}
