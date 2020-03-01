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
    
    override var image: UIImage? {
        didSet {
            guard image != nil else { return }
            isImageLoaded.value = true
        }
    }
    
    func setImage(from url: URL?) {
        guard let imageURL = url else {
            image = .imagePlaceholder
            return
        }
        if let cachedImage = FileManager.getImageFromCache(filename: imageURL.lastPathComponent) {
            image = cachedImage
            return
        }
        
        isImageLoaded.value = false
        currentImageURL = url
        image = nil
        
        ImageManager.shared.getImage(from: imageURL) { [weak self] imageResponse in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard self.currentImageURL == imageURL else { return }
                
                self.image = imageResponse
            }
        }
    }
}
