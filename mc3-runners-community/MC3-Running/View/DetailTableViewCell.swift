//
//  DetailTableViewCell.swift
//  MC3-Running
//
//  Created by Gun Eight  on 20/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
