//
//  HistoryViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 12/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//
import Foundation
import UIKit
import Charts
import Firebase
import FirebaseDatabase

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var historyTable: UITableView!
    

    var speed : [Double] = []
    var distance : [Double] = []
    var calori : [Double] = []
    var dateRun : [Date] = []
    var axisFormatDelegate: IAxisValueFormatter?
    var forday : [String] = []
    var pacer : [Double] = []
    var hisArray : [HistoryMember] = []
    var userName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart(dataEntryX: forday, dataEntryY: pacer)
        graphUiCustom()
        getHistory()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHistory()
       
        self.historyTable.reloadData()
        
    }
    
    
    func setChart(dataEntryX forX:[String],dataEntryY forY: [Double]) {
        
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries:[BarChartDataEntry] = []
        for i in 0..<forX.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]) , data:  forday as AnyObject?)
            print(dataEntry)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Pace")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChart.data = chartData
        let xAxisValue = barChart.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        
    }
    
    
    
    func getHistory()
    {
        guard let groupId = UserDefaults.standard.string(forKey: "groupId") else {return}
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {return}
        var ArrayHistory:[HistoryMember] = [HistoryMember]()
        print("group id  = \(groupId)")
        print("user id  = \(userId)")
                Database.database().reference().child("runners/\(groupId)/groups/member/\(userId)/history").observe(.value) { snapshot in
            guard let values = snapshot.value as? [String:Any] else {return}
            do{
                let decoder = JSONDecoder()
                for value in values
                {
                    let jsonData = try JSONSerialization.data(withJSONObject:  value.value , options: [] )
                    print(value.value)
                    
                    let dataString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
                    print("Lewat sini ngk = ",dataString,"\n")
                    let post = try decoder.decode(HistoryMember.self, from: jsonData)
                    ArrayHistory.append(post)
                    print("hasil array \(ArrayHistory)")
                }
                self.hisArray = ArrayHistory
                print("index 0 = \(self.hisArray[0].time_Total!)")
                print("jumalaahhhhhhhh = \(self.hisArray.count)")
                
                for i in 0..<self.hisArray.count{
                    if let pacerTemp = self.hisArray[i].member_Pace {
                        if self.pacer.count != 0{
                            DispatchQueue.global().async {
                                while true{
                                    self.pacer[i] = Double(pacerTemp)!
                                    print("ini pacer ya = \(self.pacer[i])")
                                    self.forday[i] = "\([i])"
                                    print("ini pacer ya = \(self.pacer[i])")
                                    self.forday[i] = "\([i])"
                                    sleep(1)
                                }
                            }
                        
                        }
                    }
                }
            } catch{
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.async {
            self.axisFormatDelegate = self
            self.historyTable.delegate = self
            self.historyTable.dataSource = self
            self.historyTable.reloadData()
        }
    }
    
    func graphUiCustom() {
        barChart.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.rightAxis.enabled = false
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.legend.enabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawAxisLineEnabled = false
        barChart.xAxis.axisLineColor = .clear
        historyTable.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("jumlah array = \(hisArray.count)")
        return hisArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
      
        print("index=== \(indexPath.row)")
        print("count == \(hisArray.count)")
        cell.dateLabel.text = self.hisArray[indexPath.row].member_Date!
        cell.distanceLabel.text = self.hisArray[indexPath.row].member_Distance!
        cell.calorieLabel.text = "\(self.hisArray[indexPath.row].member_Calorie!) Kcal"
        cell.speedLabel.text = "\(self.hisArray[indexPath.row].member_Pace!)min/km"
        
        if indexPath.row % 2  == 0{
            cell.backgroundColor = #colorLiteral(red: 0.9264979362, green: 0.9778947234, blue: 0.9970450997, alpha: 0.5435841182)
            
        }
        else{
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return cell
        
    }
    
    
}
extension HistoryViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return forday[Int(value)]
    }
}





