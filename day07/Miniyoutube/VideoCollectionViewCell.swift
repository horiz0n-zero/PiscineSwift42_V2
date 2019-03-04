//
//  VideoCollectionViewCell.swift
//  Miniyoutube
//
//  Created by Antoine Feuerstein on 02/03/2019.
//  Copyright © 2019 Antoine Feuerstein. All rights reserved.
//

import UIKit

let youtubeColor = UIColor.init(red: 252/255, green: 13/255, blue: 27/255, alpha: 1)

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var timeView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var channelLabel: UILabel!
    @IBOutlet var viewsCountLabel: UILabel!
    
    var video: ViewController.VideoData? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 12
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    }
    
    func fill(with videoData: ViewController.VideoData) {
        if videoData.image != nil {
            self.imageView.image = videoData.image
        }
        self.video = videoData
        self.timeLabel.text = videoData.duration
        self.timeWidthConstraint.constant = self.timeLabel.textRect(forBounds: self.titleLabel.bounds,
                                                                    limitedToNumberOfLines: 0).width + 8
        self.titleLabel.text = videoData.title
        self.channelLabel.text = videoData.channelTitle
        self.viewsCountLabel.text = videoData.viewsCount + " vues"
    }
    
}

extension String {
    
    func numberWithSpace() -> String {
        var new: String = ""
        var index: Int = self.count
        
        for char in self.enumerated() {
            if index % 3 == 0 {
                new.append(" ")
            }
            new.append(char.element)
            index -= 1
        }
        return new
    }
    
}
