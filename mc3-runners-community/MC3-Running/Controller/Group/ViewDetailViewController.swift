//
//  ViewDetailViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 19/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

class ViewDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var detailTabel: UITableView!

    
    var name : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        name.append("Gun (Admin)")
//        name.append("Eight")
        detailTabel.dataSource = self
        detailTabel.delegate = self
        updateTable()
        // Do any additional setup after loading the view.
    }
    
    func  updateTable()  {
        detailTabel.beginUpdates()
        let idxPath =  IndexPath(row: name.count, section: 0)
        detailTabel.insertRows(at:[idxPath] , with: .left)
        detailTabel.endUpdates()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTabel.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)  as! DetailTableViewCell
        
        cell.nameLabel.text = name[indexPath.row]
        if indexPath.row % 2  == 0{
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }
        else{
            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.300968536)
        }
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
    }
}


