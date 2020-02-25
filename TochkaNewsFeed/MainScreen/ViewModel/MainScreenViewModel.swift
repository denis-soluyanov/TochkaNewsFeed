//
//  MainScreenViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit
import CoreData

final class MainScreenViewModel: BaseScreenViewModel {
    
    private lazy var fetchResultsController: NSFetchedResultsController<Article> = {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Article.title), ascending: true)
        request.sortDescriptors = [sort]
        return CoreDataManager.shared.fetchedResultsController(with: request)
    }()
    
    private var page: Int = 1
    
    let screenTitle: String = "NewsFeed"
    
    var stopPagination: Bool = true
    
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
        if fetchFromCoreData() {
            print("Loading data from CoreData...")
            completion(true)
        } else {
            print("Loading data from network...")
            loadMoreContents(completion: completion)
        }
    }
    
    func loadMoreContents(completion: @escaping (_ dataIsAvailable: Bool) -> Void) {
        stopPagination = true
        
        let queries = [
            NewsFeedAPI.keyWords(value: "coronavirus"),
            NewsFeedAPI.page(value: page),
            NewsFeedAPI.pageSize(value: 10),
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
            Thread.sleep(forTimeInterval: 2)
            self.fetchFromCoreData()
            Thread.sleep(forTimeInterval: 2)
            completion(true)
            //            self.page += 1
            //            self.stopPagination = response.totalResults
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
