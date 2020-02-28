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
    
    let isImageLoaded = Box<Bool>(false)
    
    func setImage(from url: URL?) {
        isImageLoaded.value = false
        currentImageURL = url
        self.image = nil
        
        ImageManager.shared.getImage(from: url) { [weak self] imageResponse in
            DispatchQueue.main.async {
                guard self?.currentImageURL == url else { return }
                self?.image = imageResponse
                self?.isImageLoaded.value = true
            }
        }
    }
}
