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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! NewsFeedCell
        cell.viewModel = (viewModel.cellViewModel(at: indexPath) as! NewsFeedCellViewModel)
        return cell
    }
}

extension MainViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        print("visible height = \(visibleHeight)")
        
        let y = scrollView.contentOffset.y + scrollView.contentInset.top
        print("y = \(y)")
        
        let threshold = scrollView.contentSize.height - visibleHeight - 300
        print("threshold = \(threshold)")
        
        
        
        if y >= threshold {
            print("Load next portion of data")
//            viewModel.loadMoreContents()
        }
    }
}
