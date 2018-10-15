//
//  CreateGroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 14/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var gruopNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewCustomCreateGroup()
        // Do any additional setup after loading the view.
    }
    
    func ViewCustomCreateGroup() {
        
        titleLable.layer.cornerRadius = 15
        backgroundView.layer.cornerRadius = 10
        okButton.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 20
        
    }
}
