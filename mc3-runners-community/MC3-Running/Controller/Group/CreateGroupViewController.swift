//
//  CreateGroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 18/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

protocol CreateGroupDelegate {
    func somethingDismiss(nama: String, grup: String)
}

class CreateGroupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var CreateView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var createGroupButton: UIButton!
    
    var  delegate : CreateGroupDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomUICreate()
        usernameField.delegate = self
        groupNameField.delegate = self
        let userName = UserDefaults.standard.string(forKey: "username")
        print(userName)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CreateGroup(_ sender: Any) {
        print("delegate nih", self.delegate)
        if self.usernameField.text! == "" || self.groupNameField.text! == "" {
            showAlert(msg: "Please insert username and groupname")
        } else {
            self.dismiss(animated: false) {
                guard let delegate = self.delegate else {return}
                delegate.somethingDismiss(nama :self.usernameField.text!, grup: self.groupNameField.text!)
            }
        }
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "PPOINT", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func CustomUICreate() {
        CreateView.layer.cornerRadius = 20
        usernameField.layer.cornerRadius = 20
        groupNameField.layer.cornerRadius = 20
        
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
