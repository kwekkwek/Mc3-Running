//
//  JoinGroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 19/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit
import Firebase

protocol JoinGroupDelegate {
    func onethingDismiss(nama: String, group: String, kode: String)
}

enum PageEnum {
    case joinGroup
    case resultGroup
    case group
}

class JoinGroupViewController: UIViewController, PinCodeTextFieldDelegate {

    @IBOutlet weak var joinView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var pinEntryText: PinCodeTextField!
    
    var keyGroup = ""
    var nama: String =  ""
    var namaGroup: String =  ""
    
    var delegate : JoinGroupDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomUIJoin()
        pinEntryText.delegate = self
    }
    
    func getKey()
    {
        var counter: Int = 0
    Database.database().reference().child("runners").observe(.value) { snapshot in
            guard let values = snapshot.value as? [String:[String:Any]] else {return}
            print("ini adalah keys",values.keys)
            print("ini kode", self.pinEntryText.text!)
            do{
                for valueKey in values.keys
                {
                    counter = counter+1
                    guard let groupsDictionary = values[valueKey] else {return}
                    print("ini group dictionary = ",groupsDictionary)
                    guard let data = groupsDictionary["groups"] as? [String: Any] else {return}
                    print("data id \(data["id"]!)")
                    if "\(data["id"]!)" == self.pinEntryText.text {
                        print("ini temuan \(data["id"]!) \(data["nama"]!) \(valueKey)")
                        
                        self.keyGroup = valueKey
                        self.namaGroup = "\(data["nama"]!)"
//                        self.getMember(kode: valueKey)
                        
                    }
                    print("udah nih hitung \(counter) \(values.count)")
                    if counter == values.count {
                     print("cie masuk cek group")
                        self.cekGroup()
                    }
                    
                }
            }
            catch {}
        }
    }
    
    func cekGroup() {
        if self.keyGroup == "" {
            showAlert(msg: "No Group Found")
        } else{
            self.getMember(kode: self.keyGroup)
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
    
    func goToNext() {
        if nama == "" {
            setMember()
        } else{
            self.dismiss(animated: true) {
                guard let delegate = self.delegate else {return}
                delegate.onethingDismiss(nama: self.nama, group: self.namaGroup, kode: self.pinEntryText.text!)
            }
        }
    }
    
    func setMember(){
        
//        let ref = Database.database().reference().child("runners/-LQ24A7m2c0c-DAGelrc/groups/member")
//        let his = History.init(pace: "", distance: "", calories: "", dateTime: "")
//        let histoies = Histories.init(histories: [his])
//        let history:[String:Any] = [
//            "History": histoies
//        ]
        
        let ref = Database.database().reference().child("runners/\(self.keyGroup)/groups/member")
        self.nama = self.usernameField.text!
        let member:[String:Any] = [
            "namaMember": self.nama,
            "isAdmin":"false"
        ]
        ref.childByAutoId().setValue(member)
        print("addDataSend")
        self.goToNext()
    }
    
    func setHistory(){
        
        let groupId = UserDefaults.standard.string(forKey: "groupId")
        let userId = UserDefaults.standard.string(forKey: "userId")
        
        let ref = Database.database().reference().child("runners/\(groupId!)/groups/member/\(userId!)/history")
        self.nama = self.usernameField.text!
        let member:[String:Any] = [
            "pace": "12.5",
            "distance": "10",
            "calorie": "2000",
            "timeTotal": ""
        ]
        ref.childByAutoId().setValue(member)
        print("addDataSend")
        self.goToNext()
    }
    
    func getMember(kode: String){
        
        var counter: Int = 0
    
        Database.database().reference().child("runners/\(kode)/groups/member").observe(.value) { snapshot in
            guard let values = snapshot.value as? [String:[String:Any]] else {return}
            print("ini adalah keys",values.keys)
            print("ini kode", self.pinEntryText.text!)
            do{
                for valueKey in values.keys
                {
                    counter = counter + 1
                    guard let groupsDictionary = values[valueKey] else {return}
                    print("ini group dictionary = ",groupsDictionary)
                    if "\(groupsDictionary["namaMember"]!)" == self.usernameField.text {
                        print("ini member \(groupsDictionary["namaMember"]!)")
                        self.nama = "\(groupsDictionary["namaMember"]!)"
                        
                        UserDefaults.standard.set("\(groupsDictionary["namaMember"]!)", forKey: "userName")
                        UserDefaults.standard.set("\(self.keyGroup)", forKey: "groupId")
                        UserDefaults.standard.set(valueKey, forKey: "userId")
                        UserDefaults.standard.set(self.pinEntryText.text!, forKey: "groupCode")
                        UserDefaults.standard.set(self.namaGroup, forKey: "groupName")
                        
                    }
                    
                    if counter == values.count {
                        self.goToNext()
                    }
                    
                }
            }
            catch {
            }
        }
        
    }

    @IBAction func JoinGroup(_ sender: Any) {
        print("tes \(self.pinEntryText.text)")
        let kod = self.pinEntryText.text
        if kod == nil || self.usernameField.text! == ""  {
            showAlert(msg: "Please insert username and code")
        } else {
            getKey()
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
