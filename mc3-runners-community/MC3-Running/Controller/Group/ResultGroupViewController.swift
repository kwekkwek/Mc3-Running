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
        var arrayUsers:[Kelompok] = []
        Database.database().reference().child(fullKode).observe(.value) { snapshot in
            guard let value = snapshot.value as? [String:[String:Any]] else {return}
            print(value)
            do{
                for values in value
                {
                    print(values.value)
                    //dictionary = values.value
                    let jsonData = try JSONSerialization.data(withJSONObject: values.value , options: [] )
                    //print("ini jsonData = ", values,"\n")
                    //let dataString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
                    //print("ini datastring = ",dataString,"\n")
                    let post = try? JSONDecoder().decode(Kelompok.self, from: jsonData)
                    print("ini post ",post!)
                    arrayUsers.append(post!)
                    print("ini array user ",arrayUsers)
                }
//                self.users = arrayUsers
//                for user in self.users
//                {
//                    print(user)
//                }
            }
            catch {}
        }
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
