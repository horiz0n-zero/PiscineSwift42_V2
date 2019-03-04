//
//  VideoDataCollectionViewCell.swift
//  day04
//
//  Created by Antoine Feuerstein on 03/03/2019.
//  Copyright © 2019 Antoine Feuerstein. All rights reserved.
//

import UIKit
import AVFoundation

class VideoDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var percentProgress: UIProgressView!
    @IBOutlet var imageProgress: UIActivityIndicatorView!
    var player: AVPlayerLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 4
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.shadowOffset = .init(width: 0, height: 4)
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 4
        self.contentView.layer.shadowOpacity = 0.5
        self.imageProgress.startAnimating()
        self.imageProgress.hidesWhenStopped = true
        self.percentProgress.tintColor = UIColor.red
        self.addObserver(self, forKeyPath: #keyPath(VideoDataCollectionViewCell.imageView.bounds), options: [.new], context: nil)
    }
    deinit {
        self.removeObserver(self, forKeyPath: #keyPath(VideoDataCollectionViewCell.imageView.bounds), context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.player != nil {
            self.player.frame = self.imageView.bounds
        }
    }
    
}
