//
//  MainScreenViewModel.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class MainScreenViewModel: BaseScreenViewModel {
    
    func configure(view: UIView) {
        let tableView = createTableView()
        view.addSubview(tableView)
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}
