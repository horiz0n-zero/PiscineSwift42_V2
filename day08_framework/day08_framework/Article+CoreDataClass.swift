//
//  Article+CoreDataClass.swift
//  day08_framework
//
//  Created by Antoine FEUERSTEIN on 3/5/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {

    fileprivate static var managedObjectContext: NSManagedObjectContext! = {
        let frameworkBundle = Bundle(for: Article.self)
        let frameworkDataModel = frameworkBundle.url(forResource: "Article", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: frameworkDataModel)!
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        let objectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        
        objectContext.persistentStoreCoordinator = psc
        let document = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                        appropriateFor: nil, create: false)
        let storeURL = document.appendingPathComponent("article.sqlite")
            
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch { fatalError(error.localizedDescription) }
        return objectContext
    }()
    
    public class func newArticle() -> Article {
        return NSEntityDescription.insertNewObject(forEntityName: "Article",
                                                   into: Article.managedObjectContext) as! Article
    }
    
    public class func getAllArticles() -> [Article] {
        do {
            return try managedObjectContext.fetch(Article.fetchRequest())
        }
        catch { fatalError(error.localizedDescription) }
    }
    
    public class func removeArticle(article : Article) {
        Article.managedObjectContext.delete(article)
    }
    
    public class func save() {
        do {
            try Article.managedObjectContext.save()
        }
        catch { fatalError(error.localizedDescription) }
    }
    
}
