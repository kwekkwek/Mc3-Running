//
//  RunViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 12/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class RunViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addRouteButton: UIButton!
    @IBOutlet weak var recenterButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var viewContainerIcon: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //CustumViewRun()
        // Do any additional setup after loading the view.
    }
    

    func CustumViewRun()  {
        addRouteButton.layer.shadowOpacity = 0.1
        addRouteButton.layer.shadowOffset = CGSize.zero
        addRouteButton.layer.shadowRadius = 5
        addRouteButton.layer.cornerRadius = 5
        
        recenterButton.layer.shadowOpacity = 0.1
        recenterButton.layer.shadowOffset = CGSize.zero
        recenterButton.layer.shadowRadius = 5
        recenterButton.layer.cornerRadius = 5
        
        startButton.layer.shadowOpacity = 0.1
        startButton.layer.shadowOffset = CGSize.zero
        startButton.layer.shadowRadius = 5
        
        
        
        
    }

}
