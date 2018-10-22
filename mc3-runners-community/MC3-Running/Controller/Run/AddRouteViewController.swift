//
//  AddRouteViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 20/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

class AddRouteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = true
    }

}
