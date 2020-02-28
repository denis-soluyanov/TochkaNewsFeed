//
//  NewsFeedViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit
import CoreData

final class NewsFeedViewModel: BaseViewModel {
    private var page: Int = 1
    private let pageSize: Int = 20
    private var isFetchingAvailable: Bool = true
    
    private lazy var fetchResultsController: NSFetchedResultsController<Article> = {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Article.publishDate), ascending: false)
        request.sortDescriptors = [sort]
        return CoreDataManager.shared.fetchedResultsController(with: request)
    }()
    
    let screenTitle: String = "NewsFeed"
    
    var isNeedFetchMore: Bool {
        return isFetchingAvailable
    }
    
    let isDataAvailable = Box<Bool>(false)
    
    var numberOfRows: Int {
        return fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    var cellViewModelClass: BaseCellViewModel.Type {
        return NewsFeedCellViewModel.self
    }
    
    func cellViewModel(at indexPath: IndexPath) -> BaseCellViewModel {
        let object = fetchResultsController.object(at: indexPath)
        return NewsFeedCellViewModel(article: object)
    }
    
    func fetchContents() {
        guard isFetchingAvailable else { return }
        
        isFetchingAvailable = false
        fetchFromNetwork()
    }
    
    private func fetchFromNetwork() {
        let queries = [
            NewsFeedAPI.keyWords(value: "coronavirus"),
            NewsFeedAPI.page(value: page),
            NewsFeedAPI.pageSize(value: pageSize),
            NewsFeedAPI.sortBy(value: .publishedAt),
            NewsFeedAPI.language(value: .english),
            NewsFeedAPI.apiKey(value: APIKey)
        ]
        NewsFeedNetworkManager.shared.fetchNews(with: queries) { [weak self] response in
            guard let response = response else { return }
            
            self?.saveAsyncInCoreData(response.articles) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, self.fetchFromCoreData() else {
                        return
                    }
                    self.page += 1
                    self.isDataAvailable.value = true
                    self.isFetchingAvailable = (self.page * self.pageSize) <= response.totalResults
                }
            }
        }
    }
    
    private func saveAsyncInCoreData(_ response: [ArticleResponse], completion: @escaping () -> Void) {
        CoreDataManager.shared.saveAsync(Article.self, populateFrom: response, completion: completion)
    }
    
    private func fetchFromCoreData() -> Bool {
        do {
            try fetchResultsController.performFetch()
            return !(fetchResultsController.fetchedObjects?.isEmpty ?? false)
        } catch let error as NSError {
            print("Fetching error: \(error); \(error.userInfo)")
            return false
        }
    }
}
