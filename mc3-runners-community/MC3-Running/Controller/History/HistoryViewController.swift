//
//  HistoryViewController.swift
//  MC3-Running
//
//  Created by Gun Eight  on 12/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//
import Foundation
import UIKit
import SwiftCharts
import Charts

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var historyTable: UITableView!
    

    var speed : [Double] = []
    var distance : [Double] = []
    var calori : [Double] = []
    var dateRun : [Date] = []
    var axisFormatDelegate: IAxisValueFormatter?
    var days : [String] = []
    var pacer : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self
            historyTable.delegate = self
        historyTable.dataSource = self
        
        speed.append(10.2)
        distance.append(5.14)
        calori.append(203.18)
        dateRun.append(NSDate() as Date)
        days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        pacer = [10,5,6,9,4,8,7]
        setChart(dataEntryX: days, dataEntryY: pacer)
        graphUiCustom()
       
    }
    func setChart(dataEntryX forX:[String],dataEntryY forY: [Double]) {
        
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries:[BarChartDataEntry] = []
        for i in 0..<forX.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]) , data:  days as AnyObject?)
            print(dataEntry)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Pace")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChart.data = chartData
        let xAxisValue = barChart.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        
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
extension HistoryViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return days[Int(value)]
    }
}





