//
//  HistoryViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 12/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var historyTable: UITableView!
    

    var speed : [Double] = []
    var distance : [Double] = []
    var calori : [Double] = []
    var dateRun : [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

            historyTable.delegate = self
        historyTable.dataSource = self
        
        speed.append(10.2)
        distance.append(5.14)
        calori.append(203.18)
        dateRun.append(NSDate() as Date)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        cell.speedLabel.text = "\(speed[indexPath.row])"
         cell.distanceLabel.text = "\(distance[indexPath.row])"
         cell.calorieLabel.text = "\(calori[indexPath.row])"
        cell.dateLabel.text = "\(dateRun[indexPath.row])"
        
        
        if indexPath.row % 2  == 0{
            cell.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            
        }
        else{
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return cell
        
    }
    
    

}






