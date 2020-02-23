//
//  NewsFeedCellViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class NewsFeedCellViewModel: BaseCellViewModel {
    
    static let cellClass   : UITableViewCell.Type = NewsFeedCell.self
    static let cellReuseId : String  = "NewsFeedCellReuseId"
    static let cellHeight  : CGFloat = 100.0
    
    let title       = Box<String>("")
    let description = Box<String>("")
    let image       = Box<UIImage?>(.imagePlaceholder)
    
    init(article: ArticleResponse) {
        title.value = article.title
        description.value = article.description
    }
}
