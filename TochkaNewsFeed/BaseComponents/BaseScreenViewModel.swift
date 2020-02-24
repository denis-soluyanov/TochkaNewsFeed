//
//  BaseScreenViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit
import CoreData

protocol BaseScreenViewModel: class {
    
    var screenTitle: String { get }
    
    var numberOfRows: Int { get }
    
    var stopPagination: Bool { get set }
    
    var delegate: NSFetchedResultsControllerDelegate? { get set }
    
    var cellViewModelClass: BaseCellViewModel.Type { get }
    
    func cellViewModel(at indexPath: IndexPath) -> BaseCellViewModel
    
    func loadMoreContents()
    
    func fetch()
}
