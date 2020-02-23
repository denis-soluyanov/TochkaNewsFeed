//
//  MainScreenViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class MainScreenViewModel: BaseScreenViewModel {
    private let articles = Box<[ArticleResponse]>([])
    
    var numberOfRows: Int {
        return articles.value.count
    }
    
    let screenTitle: String = "NewsFeed"
    
    var cellViewModelClass: BaseCellViewModel.Type {
        return NewsFeedCellViewModel.self
    }
    
    func cellViewModel(at indexPath: IndexPath) -> BaseCellViewModel {
        return NewsFeedCellViewModel(article: articles.value[indexPath.row])
    }
    
    func fetch() {
        let queries = [ NewsFeedAPI.keyWords(value: "coronavirus") ]
        NewsFeedNetworkManager.shared.fetchNews(with: queries) { response in
            guard let articles = response else {
                return
            }
            self.articles.value = articles
        }
    }
    
    
}
