//
//  BaseCellViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

protocol BaseCellViewModel: class {
    
    static var cellClass: UITableViewCell.Type { get }
    
    static var cellReuseIdentifier: String { get }
    
    func configure(cell: UITableViewCell)
}
