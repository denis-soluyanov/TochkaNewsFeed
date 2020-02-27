//
//  WebImageView.swift
//  TochkaNewsFeed
//
//  Created by den on 25.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class WebImageView: UIImageView {
    private var currentImageURL: URL?
    
    func setImage(from url: URL?) {
        guard let imageURL = url else {
            self.image = .imagePlaceholder
            return
        }
        
        currentImageURL = imageURL
        self.image = nil
        
        if let cachedImage = FileManager.getImageFromCache(filename: imageURL.lastPathComponent) {
            self.image = cachedImage
            return
        }
 
        NewsFeedNetworkManager.shared.fetchImage(from: imageURL) { [weak self] imageResponse in
            DispatchQueue.main.async {
                guard let image = imageResponse else {
                    self?.image = .imagePlaceholder
                    return
                }
                if self?.currentImageURL == imageURL {
                    self?.image = image
                }
                FileManager.saveInCache(image: image, filename: imageURL.lastPathComponent)
            }
        }
    }
    
    
    
}
