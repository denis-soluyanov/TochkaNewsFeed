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
    
    private lazy var cellReuseIdentifier: String = {
        return viewModel.cellViewModelClass.cellReuseIdentifier
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        let cellClass = viewModel.cellViewModelClass.cellClass
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass, forCellReuseIdentifier: cellReuseIdentifier)
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
        
        view.addSubview(tableView)
        setConstraintsForTableView()
        
        let queries = [
            NewsFeedAPI.keyWords(value: "coronavirus"),
            NewsFeedAPI.language(value: .russian)
        ]
//        NewsFeedNetworkManager.shared.fetchNews(with: queries) { response in
//            
//        }
    }
    
    private func setConstraintsForTableView() {
        let safeArea = view.safeAreaLayoutGuide
        
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor)
            .isActive = true
        tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor)
            .isActive = true
        tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
            .isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
            .isActive = true
    }
}


// MARK: - UITableViewDataSource && UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! NewsFeedCell
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
//        let y = scrollView.contentOffset.y + scrollView.contentInset.top
//        let threshold = scrollView.contentSize.height - visibleHeight - 300
//
//        if y >= threshold, !viewModel.stopPagination {
//            viewModel.loadMore()
//        }
    }
}
