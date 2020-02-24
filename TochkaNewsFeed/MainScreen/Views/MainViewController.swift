//
//  MainViewController.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class MainViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
//        viewModel.loadMoreContents()
        viewModel.fetch()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! NewsFeedCell
        cell.viewModel = (viewModel.cellViewModel(at: indexPath) as! NewsFeedCellViewModel)
        return cell
    }
}

extension MainViewController {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
//        let y = scrollView.contentOffset.y + scrollView.contentInset.top
//        let threshold = scrollView.contentSize.height - visibleHeight - 300
//
//        if y >= threshold, viewModel.stopPagination {
//            viewModel.loadMoreContents()
//        }
//    }
}
