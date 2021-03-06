//
//  Article.swift
//  TochkaNewsFeed
//
//  Created by den on 23.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//
//

import CoreData

@objc(Article)
public class Article: NSManagedObject, Populatable {
    typealias TSource = ArticleResponse
    
    convenience init(populateFrom object: TSource, context: NSManagedObjectContext) {
        self.init(context: context)
        populate(from: object)
    }
    
    func populate(from object: TSource) {
        title = object.title
        articleDescription = object.description
        urlToImage = URL(string: object.urlToImage ?? "")
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
