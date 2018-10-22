//
//  CreateGroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 18/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

protocol CreateGroupDelegate {
    func somethingDismiss()
}

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var CreateView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var createGroupButton: UIButton!
    
    var  delegate : CreateGroupDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomUICreate()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CreateGroup(_ sender: Any) {
        
        self.dismiss(animated: false) {
            guard let delegate = self.delegate else {return}
            delegate.somethingDismiss()
        }
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func CustomUICreate() {
        CreateView.layer.cornerRadius = 20
        usernameField.layer.cornerRadius = 20
        groupNameField.layer.cornerRadius = 20
        
    }

}
