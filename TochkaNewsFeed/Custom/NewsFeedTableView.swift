//
//  NewsFeedTableView.swift
//  TochkaNewsFeed
//
//  Created by den on 28.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class NewsFeedTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        backgroundColor = .clear
        separatorStyle  = .singleLine
        allowsSelection = false
        tableFooterView = UIView()
        translatesAutoresizingMaskIntoConstraints = false
    }
}
