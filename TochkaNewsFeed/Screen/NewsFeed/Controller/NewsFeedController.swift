//
//  NewsFeedController.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class NewsFeedController: UIViewController {
    private let viewModel: NewsFeedViewModel
    
    private lazy var cellReuseId: String = {
        return String(describing: viewModel.cellViewModelClass.cellClass.self)
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        let cellClass = viewModel.cellViewModelClass.cellClass
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle  = .singleLine
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.register(cellClass, forCellReuseIdentifier: cellReuseId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        setConstraintsForTableView()
        setConstraintsForActivityIndicator()
        setupNavigationBar()
        activityIndicator.startAnimating()
    }
    
    init(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.isDataAvailable.bind { [weak self] isDataAvailable in
            guard isDataAvailable else { return }
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupNavigationBar() {
        navigationItem.title = viewModel.screenTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setConstraintsForTableView() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
            .isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            .isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            .isActive = true
    }
    
    private func setConstraintsForActivityIndicator() {
        activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
            .isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
            .isActive = true
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension NewsFeedController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! NewsFeedCell
        cell.viewModel = (viewModel.cellViewModel(at: indexPath) as! NewsFeedCellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellViewModelClass.cellHeight
    }
}


// MARK: - UIScrollViewDelegate
extension NewsFeedController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diff = contentHeight - scrollView.frame.height
        
        if offsetY > diff, viewModel.isFetchingAvailable {
            viewModel.fetchContents()
        }
    }
}
