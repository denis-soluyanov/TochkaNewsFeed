//
//  FileManagerExtension.swift
//  TochkaNewsFeed
//
//  Created by den on 27.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

extension FileManager {
    static var cacheDirectoryURL: URL {
        return `default`.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    static func getURLInCacheDirectory(for filename: String) -> URL {
        return cacheDirectoryURL.appendingPathComponent(filename)
    }
    
    static func saveInCache(image: UIImage, filename: String) {
        DispatchQueue.global(qos: .utility).async {
            guard let data = image.jpegData(compressionQuality: 0.7) else { return }
            let path = getURLInCacheDirectory(for: filename).path
            `default`.createFile(atPath: path, contents: data)
        }
    }
    
    static func getImageFromCache(filename: String) -> UIImage? {
        let url = getURLInCacheDirectory(for: filename)
        return UIImage(contentsOfFile: url.path)
    }
}
