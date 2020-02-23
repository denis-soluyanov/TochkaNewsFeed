//
//  BaseCellViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

protocol BaseCellViewModel: class {
    
    static var cellClass   : UITableViewCell.Type { get }
    static var cellReuseId : String  { get }
    static var cellHeight  : CGFloat { get }
    
    var title       : Box<String>   { get }
    var description : Box<String>   { get }
    var image       : Box<UIImage?> { get }
}
