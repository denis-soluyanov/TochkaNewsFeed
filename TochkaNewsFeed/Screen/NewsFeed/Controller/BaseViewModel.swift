//
//  BaseViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import Foundation

protocol BaseViewModel: class {
    
    var screenTitle: String { get }
    
    var isDataAvailable: Box<Bool> { get }
    
    var isFetchingAvailable: Bool { get }
    
    var numberOfRows: Int { get }
    
    var cellViewModelClass: BaseCellViewModel.Type { get }
    
    func cellViewModel(at indexPath: IndexPath) -> BaseCellViewModel

    func fetchContents()
}
