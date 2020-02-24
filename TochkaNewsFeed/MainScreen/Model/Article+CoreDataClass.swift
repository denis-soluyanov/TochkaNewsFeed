//
//  Article+CoreDataClass.swift
//  TochkaNewsFeed
//
//  Created by den on 23.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//
//

import CoreData

@objc(Article)
public class Article: NSManagedObject, Populatable {
    typealias T = ArticleResponse
    
    convenience init(populateFrom object: T, context: NSManagedObjectContext) {
        self.init(context: context)
        populateFrom(object: object)
    }
    
    func populateFrom(object: T) {
        title = object.title
        articleDescription = object.description
        urlToImage = URL(string: object.urlToImage)
        publishDate = ISO8601DateFormatter().date(from: object.publishedAt)
    }
}

extension Article {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var title: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var urlToImage: URL?
    @NSManaged public var publishDate: Date?
}
