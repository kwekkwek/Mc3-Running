//
//  HistoryTableViewCell.swift
//  MC3-Running
//
//  Created by Gun Eight  on 21/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
  
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
