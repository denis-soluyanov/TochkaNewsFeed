//
//  NewsFeedCellViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class NewsFeedCellViewModel: BaseCellViewModel {
    
    static var cellClass: UITableViewCell.Type = NewsFeedCell.self
    
    static let cellReuseIdentifier: String = "NewsFeedCellReuseIdentifier"
    
    func configure(cell: UITableViewCell) {
        cell.textLabel?.text = "Text"
    }
}
