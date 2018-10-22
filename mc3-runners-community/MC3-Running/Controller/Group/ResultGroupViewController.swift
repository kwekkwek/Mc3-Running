//
//  ResultGroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 18/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

class ResultGroupViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var code1Label: UILabel!
    @IBOutlet weak var code2Lable: UILabel!
    @IBOutlet weak var code3Label: UILabel!
    @IBOutlet weak var code4Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        customUIResult()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func ViewGroupButton(_ sender: Any) {
    
    
    }
    

    @IBAction func leaveGroupButton(_ sender: Any) {
    }
    
    func customUIResult()  {
        usernameLabel.layer.borderWidth = 0.5
        groupNameLabel.layer.borderWidth = 0.5
        usernameLabel.layer.cornerRadius = 10
        groupNameLabel.layer.cornerRadius = 10
         code1Label.layer.masksToBounds  = true
         code2Lable.layer.masksToBounds  = true
         code3Label.layer.masksToBounds  = true
         code4Label.layer.masksToBounds  = true
        code1Label.layer.cornerRadius = 10
        code2Lable.layer.cornerRadius = 10
        code3Label.layer.cornerRadius = 10
        code4Label.layer.cornerRadius = 10
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
