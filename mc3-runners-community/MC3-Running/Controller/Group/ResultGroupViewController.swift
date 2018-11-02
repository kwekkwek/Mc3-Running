//
//  ResultGroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 18/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit
import Firebase

class ResultGroupViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var code1Label: UILabel!
    @IBOutlet weak var code2Lable: UILabel!
    @IBOutlet weak var code3Label: UILabel!
    @IBOutlet weak var code4Label: UILabel!
    
    var name = ""
    var groupName = ""
    var code1: String = ""
    var code2: String = ""
    var code3: String = ""
    var code4: String = ""
    var fullKode = ""
    var key = ""
    var arrayUser: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customUIResult()
        usernameLabel.text = name
        groupNameLabel.text = groupName
        code1Label.text = code1
        code2Lable.text = code2
        code3Label.text = code3
        code4Label.text = code4
        getKey()
    }
    
    func getKey()
    {
        
        Database.database().reference().child("runners").observe(.value) { snapshot in
            guard let values = snapshot.value as? [String:[String:Any]] else {return}
            print("ini adalah keys",values.keys)
            print("ini kode", self.fullKode)
            do{
                for valueKey in values.keys
                {
                    guard let groupsDictionary = values[valueKey] else {return}
                    print("ini group dictionary = ",groupsDictionary)
                    guard let data = groupsDictionary["groups"] as? [String: Any] else {return}
                    print("data id \(data["id"]!)")
                    if "\(data["id"]!)" == self.fullKode {
                        print("ini temuan \(data["id"]) \(data["nama"]) \(valueKey)")
                        
                        self.getMember(kode: valueKey)
                        
                    }
                }
            }
            catch {}
        }
    }
    
    func getMember(kode: String) {
        
        Database.database().reference().child("runners/\(kode)/groups/member").observe(.value) { snapshot in
            guard let values = snapshot.value as? [String:[String:Any]] else {return}
            print("ini adalah keys",values.keys)
            self.arrayUser.removeAll()
            let userName = UserDefaults.standard.string(forKey: "userName")
            do{
                for valueKey in values.keys
                {
                    guard let groupsDictionary = values[valueKey] else {return}
                    print("ini group dictionary = ",groupsDictionary)
                    if "\(groupsDictionary["namaMember"]!)" != userName!{
                    self.arrayUser.append("\(groupsDictionary["namaMember"]!)")
                    }
                }
            }
            catch {}
        }
        
    }

    @IBAction func ViewGroupButton(_ sender: Any) {
    
    }
    

    @IBAction func leaveGroupButton(_ sender: Any) {
        
        UserDefaults.standard.set("", forKey: "userName")
        UserDefaults.standard.set("", forKey: "groupId")
        UserDefaults.standard.set("", forKey: "userId")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailGroup" {
            let vc = segue.destination as! ViewDetailViewController
            vc.name = arrayUser
        } else if segue.identifier == "LeaveGroup" {
            
        }
        
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
            self.tabBarController?.tabBar.isHidden = false
        }
    
    
}
