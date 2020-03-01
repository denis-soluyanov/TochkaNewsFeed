//
//  Populatable.swift
//  TochkaNewsFeed
//
//  Created by den on 24.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import CoreData

protocol Populatable: NSManagedObject {
    associatedtype TSource
    
    func populate(from object: TSource)
}
