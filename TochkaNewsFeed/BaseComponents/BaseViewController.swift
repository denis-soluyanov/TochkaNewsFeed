//
//  BaseViewController.swift
//  TochkaNewsFeed
//
//  Created by den on 23.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {
    private lazy var cellReuseId: String = {
        return viewModel.cellViewModelClass.cellReuseId
    }()
    
    let viewModel: BaseScreenViewModel
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var tableView: UITableView = {
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
    
    init(viewModel: BaseScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.isDataAvailable.bind { [weak self] isDataAvailable in
            guard isDataAvailable else { return }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setConstraintsForTableView()
        
        view.addSubview(activityIndicator)
        setConstraintsForActivityIndicator()
//        activityIndicator.startAnimating()
        
        setupNavigationBar()
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
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
extension BaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellViewModelClass.cellHeight
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension BaseViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("notification from fetchRC\nreloading tableView...")
        tableView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate
extension BaseViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diff = contentHeight - scrollView.frame.height
        
        if offsetY > diff, viewModel.isNeedFetchMore {
            viewModel.fetchContents()
        }
    }
}
