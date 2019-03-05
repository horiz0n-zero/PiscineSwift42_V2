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

    fileprivate static let objectModel: NSManagedObjectContext = {
        let momd = Bundle.init(for: Article.self).path(forResource: "Article", ofType: "momd")!
        let model = NSManagedObjectModel.init(contentsOf: URL.init(string: momd)!)!
        let psc = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        let context =  NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
    
        context.persistentStoreCoordinator = psc
        return context
    }()
    
    public func save() {
        if Article.objectModel.hasChanges {
            do {
                try Article.objectModel.save()
            }
            catch { fatalError(error.localizedDescription) }
        }
    }
    public class func getAllArticles() throws -> [Article] {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
    
        do {
            return try Article.objectModel.fetch(request)
        }
        catch { throw error }
    }
    public class var newArticle: Article {
        return NSEntityDescription.insertNewObject(forEntityName: "Article", into: Article.objectModel) as! Article
    }
    
}
