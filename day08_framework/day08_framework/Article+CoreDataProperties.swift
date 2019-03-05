//
//  Article+CoreDataProperties.swift
//  day08_framework
//
//  Created by Antoine FEUERSTEIN on 3/5/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var image: NSData?

}
