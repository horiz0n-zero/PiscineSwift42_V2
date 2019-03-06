//
//  ViewController.swift
//  day09
//
//  Created by Antoine FEUERSTEIN on 3/5/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit
import day08_framework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                let f = Article.newArticle()
        
                f.content = "toto"
                f.title = "toto"
                f.creationDate = NSDate.init()
                f.image = UIImagePNGRepresentation(UIImage.init(named: "1")!)! as! NSData
                let u = Article.newArticle()
        
                u.content = "titi"
                u.title = "jhjh"
                u.creationDate = NSDate.init()
                u.image = UIImagePNGRepresentation(UIImage.init(named: "2")!)! as! NSData
                Article.save()
    }

}

