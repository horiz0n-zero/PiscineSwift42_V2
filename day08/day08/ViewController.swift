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

class ViewController: UIViewController {

    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(try! FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: false))
        print(try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false))
        do {
            self.articles = try Article.getAllArticles()
        }
        catch { fatalError(error.localizedDescription) }
        
        let newArticle = Article.newArticle
        
        newArticle.content = "toto"
        newArticle.creationDate = NSDate.init()
        newArticle.modificationDate = newArticle.creationDate
        newArticle.title = "super toto"
        newArticle.save()
        print(self.articles)
    }

}

