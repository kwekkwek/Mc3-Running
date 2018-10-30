//
//  testChart.swift
//  MC3-Running
//
//  Created by Gun Eight  on 30/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import Foundation
struct DataSource {
    var Days: String
    var Paces: [Int]
}

class DataGenerator {
    
   
    
    static func data() -> [DataSource] {
        let day = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Satuday"]
        let pacer = [10,5,6,9,4,8,7]
        var run = [DataSource]()
        
        for days in day {
            let runs = DataSource(Days: days, Paces: pacer)
            run.append(runs)
        }
        
        return run
    }
}
