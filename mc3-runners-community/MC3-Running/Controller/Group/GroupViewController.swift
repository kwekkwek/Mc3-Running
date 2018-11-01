//
//  GroupViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 12/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit
import Firebase

class GroupViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var joinButton: UIButton!
    
    var mapHelp:MapHelper?
    
    let tabBarImageActive = ["groupTabBar_Active", "runTabBar_ActiveS", "historyTabBar_Active"]
    let tabBarImageInactive = ["groupTabBar_Inactive","runTabBar_Inactive","historyTabBar_Inactive" ]
    
    var namaUser = ""
    var grupUser = ""
    var key1 = ""
    var key2 = ""
    var key3 = ""
    var key4 = ""
    var fullKode = ""
    var namaGrup = ""
    var keyGroup = ""
    
    func setTabItem() {
        for i in 0 ..< tabBarImageActive.count
        {
            print("Ini item")
            self.tabBarController?.tabBar.items?[i].image = UIImage(named: tabBarImageInactive[i])
            self.tabBarController?.tabBar.items?[i].selectedImage = UIImage(named: tabBarImageActive[i])
            
            print(i)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //CustomViewGroup()
        // Do any additional setup after loading the view.
        setTabItem()
        CustomUIGroup()
        mapHelp = MapHelper()
        
        let username = UserDefaults.standard.string(forKey: "userName")
        guard let userName = username else {return}
        if userName != "" {
            grupUser = UserDefaults.standard.string(forKey: "groupName")!
            namaUser = userName
            fullKode = UserDefaults.standard.string(forKey: "groupCode")!
            let string = fullKode
            let start = String.Index(encodedOffset: 0)
            let end = String.Index(encodedOffset: 1)
            key1 = String(string[start..<end])
            let start1 = String.Index(encodedOffset: 1)
            let end1 = String.Index(encodedOffset: 2)
            key2 = String(string[start1..<end1])
            let start2 = String.Index(encodedOffset: 2)
            let end2 = String.Index(encodedOffset: 3)
            key3 = String(string[start2..<end2])
            let start3 = String.Index(encodedOffset: 3)
            let end3 = String.Index(encodedOffset: 4)
            key4 = String(string[start3..<end3])
            performSegue(withIdentifier: "ResultShow", sender: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CreateSeague" {
            let vc = segue.destination as! CreateGroupViewController
            vc.delegate = self

        } else if segue.identifier == "JoinSeague" {
            let vc = segue.destination as! JoinGroupViewController
            vc.delegate = self
        } else if segue.identifier == "ResultShow" {
            let vc = segue.destination as! ResultGroupViewController
            vc.name = namaUser
            vc.groupName = grupUser
            vc.code1 = key1
            vc.code2 = key2
            vc.code3 = key3
            vc.code4 = key4
            vc.fullKode = fullKode
        } else if segue.identifier == "JoinShow" {
            let vc = segue.destination as! ResultGroupViewController
            vc.name = namaUser
            vc.groupName = grupUser
            vc.code1 = key1
            vc.code2 = key2
            vc.code3 = key3
            vc.code4 = key4
            vc.fullKode = fullKode
        }
        print("masoeks sini dulu")
    }
    
    @IBAction func createGroup(_ sender: UIButton ) {
        
    }
    
    @IBAction func joinbutton(_ sender: UIButton) {
        
    }
    
    func CustomUIGroup()  {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9098039216, green: 0.9725490196, blue: 0.9960784314, alpha: 1)
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.9098039216, green: 0.9725490196, blue: 0.9960784314, alpha: 1)
    }
    
    func setMember(keyGroup: String){
        
        let ref = Database.database().reference().child("runners/\(keyGroup)/groups/member")
        let member:[String:Any] = [
            "namaMember": self.namaUser,
            "isAdmin":"true"
        ]
        ref.childByAutoId().setValue(member)
        print("addDataSend")
        getMember(kode: keyGroup)
    }
    
    func getMember(kode: String){
        
        var counter: Int = 0
        
        Database.database().reference().child("runners/\(kode)/groups/member").observe(.value) { snapshot in
            guard let values = snapshot.value as? [String:[String:Any]] else {return}
            print("ini adalah keys",values.keys)
            do{
                for valueKey in values.keys
                {
                    counter = counter + 1
                    guard let groupsDictionary = values[valueKey] else {return}
                    print("ini group dictionary = ",groupsDictionary)
                    if "\(groupsDictionary["namaMember"]!)" == self.namaUser {
                        print("ini member \(groupsDictionary["namaMember"]!)")
                        
                        UserDefaults.standard.set(self.namaUser, forKey: "userName")
                        UserDefaults.standard.set(self.keyGroup, forKey: "groupId")
                        UserDefaults.standard.set(valueKey, forKey: "userId")
                        UserDefaults.standard.set(self.fullKode, forKey: "groupCode")
                        UserDefaults.standard.set(self.grupUser, forKey: "groupName")
                        
                        self.performSegue(withIdentifier: "ResultShow", sender: nil)
                        
                    }
                }
            }
            catch {
            }
        }
        
    }
    
    func getKey()
    {
        var counter: Int = 0
        Database.database().reference().child("runners").observe(.value) { snapshot in
            guard let values = snapshot.value as? [String:[String:Any]] else {return}
            print("ini adalah keys",values.keys)
            print("ini kode", self.fullKode)
            do{
                for valueKey in values.keys
                {
                    counter = counter+1
                    guard let groupsDictionary = values[valueKey] else {return}
                    print("ini group dictionary = ",groupsDictionary)
                    guard let data = groupsDictionary["groups"] as? [String: Any] else {return}
                    print("data id \(data["id"]!)")
                    if "\(data["id"]!)" == self.fullKode {
                        print("ini temuan \(data["id"]!) \(data["nama"]!) \(valueKey)")
                        
                        self.keyGroup = valueKey
                        self.namaGrup = "\(data["nama"]!)"
                        
                    }
                    print("udah nih hitung \(counter) \(values.count)")
                    if counter == values.count {
                        print("cie masuk cek group")
                        self.setMember(keyGroup: self.keyGroup)
                    }
                    
                }
            }
            catch {}
        }
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    
}

extension GroupViewController : CreateGroupDelegate {
    func somethingDismiss(nama : String, grup : String) {
        print("ini ", nama, grup)
        self.namaUser = nama
        self.grupUser = grup
        key1 = String.random1()
        key2 = String.random1()
        key3 = String.random1()
        key4 = String.random1()
        fullKode = key1+key2+key3+key4
        mapHelp?.sendGroup(name: grupUser, key: fullKode)
        self.getKey()
    }
}
    
extension GroupViewController : JoinGroupDelegate {
    func onethingDismiss(nama: String, group: String, kode: String) {
        self.grupUser = group
        self.namaUser = nama
        fullKode = kode
        let string = kode
        let start = String.Index(encodedOffset: 0)
        let end = String.Index(encodedOffset: 1)
        key1 = String(string[start..<end])
        let start1 = String.Index(encodedOffset: 1)
        let end1 = String.Index(encodedOffset: 2)
        key2 = String(string[start1..<end1])
        let start2 = String.Index(encodedOffset: 2)
        let end2 = String.Index(encodedOffset: 3)
        key3 = String(string[start2..<end2])
        let start3 = String.Index(encodedOffset: 3)
        let end3 = String.Index(encodedOffset: 4)
        key4 = String(string[start3..<end3])
        print("ini sub ", kode)
        self.performSegue(withIdentifier: "JoinShow", sender: nil)
    }
}



