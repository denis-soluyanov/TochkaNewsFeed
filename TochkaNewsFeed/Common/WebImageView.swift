//
//  WebImageView.swift
//  TochkaNewsFeed
//
//  Created by den on 25.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    
    func setImage(from url: URL?) {
        guard let imageURL = url else {
            image = .imagePlaceholder
            return
        }
        
        NewsFeedNetworkManager.shared.fetchImage(from: imageURL) { [weak self] imageResponse in
            DispatchQueue.main.async {
                self?.image = imageResponse
            }
        }
    }
}
