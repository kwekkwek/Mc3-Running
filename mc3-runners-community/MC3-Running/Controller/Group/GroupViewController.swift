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
        
        //        let vc = CreateGroupViewController()
        //        vc.modalTransitionStyle = .crossDissolve
        //        vc.modalPresentationStyle = .overCurrentContext
        //        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func joinbutton(_ sender: UIButton) {
        
    }
    
    func CustomUIGroup()  {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9098039216, green: 0.9725490196, blue: 0.9960784314, alpha: 1)
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.9098039216, green: 0.9725490196, blue: 0.9960784314, alpha: 1)
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    
}

extension GroupViewController : CreateGroupDelegate {
    func somethingDismiss(nama : String, grup : String) {
        self.namaUser = nama
        self.grupUser = grup
        key1 = String.random1()
        key2 = String.random1()
        key3 = String.random1()
        key4 = String.random1()
        fullKode = key1+key2+key3+key4
        mapHelp?.sendGroup(name: namaUser, key: fullKode)
        self.performSegue(withIdentifier: "ResultShow", sender: nil)
        print("ini ", nama, grup)
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



