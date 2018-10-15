//
//  GroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 12/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var joinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomViewGroup()
        // Do any additional setup after loading the view.
    }
    

    func CustomViewGroup() {
        createButton.layer.shadowOpacity = 0.2
        createButton.layer.shadowRadius = 10
        createButton.layer.shadowOffset = CGSize.zero
        createButton.layer.cornerRadius = 20
        
        
        joinButton.layer.shadowOpacity = 0.2
        joinButton.layer.shadowRadius = 10
        joinButton.layer.shadowOffset = CGSize.zero
        joinButton.layer.cornerRadius = 20
    }

}
