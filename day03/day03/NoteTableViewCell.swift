//
//  NoteTableViewCell.swift
//  day03
//
//  Created by Antoine FEUERSTEIN on 3/1/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func fill(with note: Note) {
        self.titleLabel.text = note.title
        self.descriptionLabel.text = note.description
        if let updated = note.updated {
            self.dateLabel.text = self.dateToText(date: updated)
        }
        else {
            self.dateLabel.text = self.dateToText(date: note.created)
        }
    }
    
    func dateToText(date: Date) -> String {
        let formatter = DateFormatter.init()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
}
