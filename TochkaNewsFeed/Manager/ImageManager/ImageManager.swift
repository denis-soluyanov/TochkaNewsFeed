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
    
    func getImage(from imageURL: URL, completion: @escaping (UIImage?) -> Void) {
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
