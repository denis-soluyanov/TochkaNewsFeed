//
//  NewsFeedNetworkManager.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class NewsFeedNetworkManager {
    private let session : URLSession
    
    static let shared: NewsFeedNetworkManager = {
        return NewsFeedNetworkManager()
    }()
    
    private init() {
        session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    }
 
    func fetchNews(with queries: [NewsFeedAPI], completion: @escaping (NewsFeedResponse?) -> Void) {
        guard let request = URLRequest(domain: APIEndpoint, queries: queries.map{ $0.urlQueryItem }) else {
            completion(nil)
            return
        }
        fetch(request: request) { jsonData, error in
            guard let jsonData = jsonData else { return }
            guard error == nil else {
                if let response = try? JSONDecoder().decode(NewsFeedErrorResponse.self, from: jsonData) {
                    print(response)
                }
                return
            }
            do {
                let newsResponse = try JSONDecoder().decode(NewsFeedResponse.self, from: jsonData)
                completion(newsResponse)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        fetch(request: URLRequest(url: url)) { data, _ in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
    private func fetch(request: URLRequest, completion: @escaping (Data?, NetworkError?) -> Void) {
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, .requestError(error!))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(nil, .responseTypeError)
                return
            }
            guard let data = data else {
                completion(nil, .dataError)
                return
            }
            guard response.statusCode == 200 else {
                completion(data, .responseCode(response.statusCode))
                return
            }
            CoreDataManager.shared.saveViewContext()
            completion(data, nil)
        }.resume()
    }
}
