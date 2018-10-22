//
//  JoinGroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 19/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

enum PageEnum {
    case joinGroup
    case resultGroup
    case group
}

protocol JoinGroupDelegate {
    func onethingDismiss()
}
class JoinGroupViewController: UIViewController {

    @IBOutlet weak var joinView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var Code1: UITextField!
    @IBOutlet weak var Code3: UITextField!
    @IBOutlet weak var Code4: UITextField!
    @IBOutlet weak var Code2: UITextField!
    
    @IBOutlet weak var joinButton: UIButton!
    
    var delegate : JoinGroupDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomUIJoin()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func JoinGroup(_ sender: Any) {
        self.dismiss(animated: false){
            guard let delegate = self.delegate else {return}
            delegate.onethingDismiss()
        }
    }
    
    @IBAction func CloseJoin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func CustomUIJoin()  {
        joinView.layer.cornerRadius = 20
        usernameField.layer.cornerRadius = 20
        
        
    }
    
}
