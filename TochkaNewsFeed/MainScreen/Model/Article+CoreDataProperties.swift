//
//  Article+CoreDataProperties.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//
//

import Foundation
import CoreData

extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var urlToImage: URL?
}
