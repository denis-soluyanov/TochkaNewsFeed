//
//  ImageManager.swift
//  TochkaNewsFeed
//
//  Created by den on 28.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class ImageManager {
    private init() {}
    
    static let shared: ImageManager = {
        return ImageManager()
    }()
    
    func getImage(from imageURL: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = imageURL else {
            completion(.imagePlaceholder)
            return
        }
        guard !imageURL.isFileURL else {
//            completion(UIImage(contentsOfFile: imageURL.path))
            return
        }
        if let cachedImage = FileManager.getImageFromCache(filename: imageURL.lastPathComponent) {
            completion(cachedImage)
            return
        }
        
        NewsFeedNetworkManager.shared.fetchImage(from: imageURL) { imageResponse in
            guard let image = imageResponse else {
                completion(.imagePlaceholder)
                return
            }
            FileManager.saveInCache(image: image, filename: imageURL.lastPathComponent)
            completion(image)
        }
    }
}
