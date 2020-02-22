//
//  MainScreenViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class MainScreenViewModel: BaseScreenViewModel {
    private var articles: [ArticleResponse] = []
    
    var cellViewModelClass: BaseCellViewModel.Type {
        return NewsFeedCellViewModel.self
    }
    
    var stopPagination: Bool = true
    
    func configure(view: UIView) {
        //
    }
    
    func numberOfRows() -> Int {
        return articles.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> BaseCellViewModel? {
//        NewsFeedCell(
        return NewsFeedCellViewModel()
    }
}
