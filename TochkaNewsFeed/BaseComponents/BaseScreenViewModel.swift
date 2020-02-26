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
    
    var isNeedFetchMore: Bool { get }
    
    var isDataAvailable: Box<Bool> { get }
    
    var cellViewModelClass: BaseCellViewModel.Type { get }
    
    func cellViewModel(at indexPath: IndexPath) -> BaseCellViewModel

    func fetchContents()
}
