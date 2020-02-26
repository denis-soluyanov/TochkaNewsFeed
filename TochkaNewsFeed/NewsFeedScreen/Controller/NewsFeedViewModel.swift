//
//  NewsFeedViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit
import CoreData

final class NewsFeedViewModel: BaseScreenViewModel {
    private var page: Int = 1
    private let pageSize: Int = 10
    private var isFetchingAvailable: Bool = true
    
    private lazy var fetchResultsController: NSFetchedResultsController<Article> = {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Article.publishDate), ascending: true)
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
    
    weak var delegate: NSFetchedResultsControllerDelegate? {
        willSet {
            fetchResultsController.delegate = newValue
        }
    }
    
    var cellViewModelClass: BaseCellViewModel.Type {
        return NewsFeedCellViewModel.self
    }
    
    func cellViewModel(at indexPath: IndexPath) -> BaseCellViewModel {
        let object = fetchResultsController.object(at: indexPath)
        return NewsFeedCellViewModel(article: object)
    }
    
    func fetchContents() {
        guard isFetchingAvailable else {
            print("Fetching is anavailable now")
            return
        }
        
        isFetchingAvailable = false
        
        print("Loading data from network...")
        fetchFromNetwork()
    }
    
    private func fetchFromNetwork() {
        let queries = [
            NewsFeedAPI.keyWords(value: "coronavirus"),
            NewsFeedAPI.page(value: page),
            NewsFeedAPI.pageSize(value: pageSize),
            NewsFeedAPI.apiKey(value: NEWS_FEED_API_KEY)
        ]
        NewsFeedNetworkManager.shared.fetchNews(with: queries) { [weak self] response in
            guard let response = response else { return }
            
            self?.saveAsyncInCoreData(response.articles) {
                print("Loading data from CoreData...")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, self.fetchFromCoreData() else {
                        print("No data available in CoreData")
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
        CoreDataManager.shared.save { context in
            for articleResponse in response {
                _ = Article(populateFrom: articleResponse, context: context)
            }
            do {
                try context.save()
                completion()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
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
