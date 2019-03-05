//
//  ArticleTableViewCell.swift
//  todayExtension
//
//  Created by Antoine Feuerstein on 05/03/2019.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit
import day08_framework

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func fill(with: Article) {
        if let data = with.image, let image = UIImage.init(data: data as Data) {
            self.articleImageView.image = image
        }
        self.articleTitle.text = with.title
        self.articleDescription.text = with.content
    }
    
}
