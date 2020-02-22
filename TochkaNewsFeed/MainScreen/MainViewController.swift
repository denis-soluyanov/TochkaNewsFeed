//
//  MainViewController.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private let viewModel: BaseScreenViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: BaseScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
//        
//        let query = NewsFeedAPI.pageSize(value: 2)
//        let query2 = NewsFeedAPI.sortBy
//        
//        
//        let request = NewsFeedNetworkManager.shared.request
//        
//        
//        
//        NewsFeedNetworkManager.shared.fetch(request: request)
        
    }
}

