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
    
    
    let tabBarImageActive = ["groupTabBar_Active", "runTabBar_ActiveS", "historyTabBar_Active"]
    let tabBarImageInactive = ["groupTabBar_Inactive","runTabBar_Inactive","historyTabBar_Inactive" ]
    
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "ResultShow" {
//            return
//        } else if segue.identifier == "ResultShowFromJoin" {
//            let vc = segue.destination as! ResultGroupViewController
//            vc.code1Label.text = "9"
//        }
        
        if segue.identifier == "CreateSeague" {
            let vc = segue.destination as! CreateGroupViewController
            vc.delegate = self

        } else if segue.identifier == "JoinSeague" {
            let vc = segue.destination as! JoinGroupViewController
            vc.delegate = self
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
    func somethingDismiss() {
        self.performSegue(withIdentifier: "ResultShow", sender: nil)
    }
}
    
extension GroupViewController : JoinGroupDelegate {
        func onethingDismiss() {
    self.performSegue(withIdentifier: "JoinShow", sender: nil)
    }
}



