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
    private let pageSize: Int = 20
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
    
    func fetchContents(completion: @escaping (_ dataIsAvailable: Bool) -> Void) {
        guard isFetchingAvailable else { return }
        
        isFetchingAvailable = false
        
        if fetchFromCoreData() {
            print("Loading data from CoreData...")
            completion(true)
        } else {
            print("Loading data from network...")
            loadMoreContents(completion: completion)
        }
    }
    
    
    func fetchMock() {
        print("fetching data...")
        isFetchingAvailable = false
        DispatchQueue.global(qos: .utility).async { [weak self] in
            print("Doing some shit...")
            Thread.sleep(forTimeInterval: 5)
            self?.isFetchingAvailable = true
        }
    }
    
    func loadMoreContents(completion: @escaping (_ dataIsAvailable: Bool) -> Void) {
        let queries = [
            NewsFeedAPI.keyWords(value: "coronavirus"),
            NewsFeedAPI.page(value: page),
            NewsFeedAPI.apiKey(value: NEWS_FEED_API_KEY)
        ]
        NewsFeedNetworkManager.shared.fetchNews(with: queries) {
            [weak self] response in
            
            guard let self = self, let response = response else {
                completion(false)
                print("some error")
                return
            }
            self.saveArticlesInCoreData(response.articles)
            self.page += 1
            self.isFetchingAvailable = (self.page * self.pageSize) <= response.totalResults
        }
    }
    
    private func saveArticlesInCoreData(_ articlesResponse: [ArticleResponse]) {
        CoreDataManager.shared.save { context in
            
            for articleResponse in articlesResponse {
                _ = Article(populateFrom: articleResponse, context: context)
            }
            
            do {
                try context.save()
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
