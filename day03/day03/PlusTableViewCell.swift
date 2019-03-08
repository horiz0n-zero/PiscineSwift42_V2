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
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.red.withAlphaComponent(0.3).cgColor
    }

}
