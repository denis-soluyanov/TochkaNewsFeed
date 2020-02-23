//
//  BaseViewController.swift
//  TochkaNewsFeed
//
//  Created by den on 23.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let viewModel: BaseScreenViewModel
    
    private lazy var cellReuseIdentifier: String = {
        return viewModel.cellViewModelClass.cellReuseId
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        let cellClass = viewModel.cellViewModelClass.cellClass
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(cellClass, forCellReuseIdentifier: cellReuseIdentifier)
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
        view.addSubview(tableView)
        setConstraintsForTableView()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
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
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension BaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellViewModelClass.cellHeight
    }
}
