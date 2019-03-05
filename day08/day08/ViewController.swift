//
//  ViewController.swift
//  day08
//
//  Created by Antoine FEUERSTEIN on 3/5/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit
import day08_framework
import CoreData

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleContent: UILabel!
    @IBOutlet var articleDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class ViewController: UIViewController, UITableViewDataSource {
    
    var articles: [Article] = []
    
    @IBOutlet var articleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.articles = Article.getAllArticles()
        self.articleTableView.dataSource = self
//        let f = Article.newArticle()
//
//        f.content = "toto"
//        f.title = "toto"
//        f.creationDate = NSDate.init()
//        f.image = UIImagePNGRepresentation(UIImage.init(named: "1")!)! as! NSData
//        let u = Article.newArticle()
//
//        u.content = "titi"
//        u.title = "jhjh"
//        u.creationDate = NSDate.init()
//        u.image = UIImagePNGRepresentation(UIImage.init(named: "2")!)! as! NSData
//        Article.save()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        let article = self.articles[indexPath.row]
        let formatter = DateFormatter.init()
        
        if let data = article.image as Data? {
            cell.articleImage.image = UIImage.init(data: data)
        }
        cell.articleTitle.text = article.title
        cell.articleContent.text = article.content
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        if let date = article.creationDate as Date? {
            cell.articleDate.text = formatter.string(from: date)
        }
        return cell
    }
    
}

