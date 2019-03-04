//
//  CommentTableViewCell.swift
//  Miniyoutube
//
//  Created by Antoine Feuerstein on 03/03/2019.
//  Copyright © 2019 Antoine Feuerstein. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var separatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorView.layer.cornerRadius = self.separatorView.bounds.height / 2
    
    }

    
    
}
