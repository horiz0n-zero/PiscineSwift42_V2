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

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextview: UITextView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var cameraImage: UIButton!
    @IBOutlet var photoImage: UIButton!
    
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in [self.cancelButton, self.addbutton, self.cameraImage, self.photoImage, self.titleTextField, self.descriptionTextview, self.imageView] as! [UIView] {
            button.layer.cornerRadius = 6
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.masksToBounds = true
            button.clipsToBounds = true
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addTapped(_ sender: Any) {
        guard let title = self.titleTextField.text, title != "", let content = self.descriptionTextview.text, content != "",
            let image = self.imageView.image else {
                let alert = UIAlertController.init(title: "Error", message: "content missing", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
                return self.present(alert, animated: true, completion: nil)
        }
        
        let article = Article.newArticle()
        
        article.content = content
        article.title = title
        article.creationDate = NSDate.init()
        article.image = UIImagePNGRepresentation(image) as NSData?
        ViewController.shared.articles.append(article)
        ViewController.shared.articleTableView.reloadSections(IndexSet.init(integersIn: 0...0), with: .automatic)
        Article.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        let picker = UIImagePickerController.init()
        
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func photoTapped(_ sender: Any) {
        let picker = UIImagePickerController.init()
        
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        self.imageView.image = selectedImage
    }
    
}

class ViewController: UIViewController, UITableViewDataSource {
    
    var articles: [Article] = []
    
    @IBOutlet var articleTableView: UITableView!
    @IBAction func addArticleTapped(sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController {
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    static var shared: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.shared = self
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

