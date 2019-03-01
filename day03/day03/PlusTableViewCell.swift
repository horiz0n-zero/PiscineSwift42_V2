//
//  PlusTableViewCell.swift
//  day03
//
//  Created by Antoine FEUERSTEIN on 3/1/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit

class PlusTableViewCell: UITableViewCell {

    @IBOutlet var plusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.plusLabel.layer.cornerRadius = 8
    }

}
