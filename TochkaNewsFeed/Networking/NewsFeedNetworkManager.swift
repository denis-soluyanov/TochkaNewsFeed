//
//  NewsFeedNetworkManager.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import Foundation

final class NewsFeedNetworkManager {
    private let session : URLSession
    private let apiKey  : String
    private let domain  : String
    
    static let shared: NewsFeedNetworkManager = {
        let instance = NewsFeedNetworkManager()
        return instance
    }()
    
    private init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
        apiKey  = NEWS_FEED_API_KEY
        domain  = NEWS_FEED_API_DOMAIN
    }
    
    func fetch(request: URLRequest) {
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            guard response.statusCode == 200 else {
                print("response: \(response.statusCode)")
                print(response)
                return
            }
            guard error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
            guard let jsonData = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: jsonData)
                
                for article in response.articles {
                    print(article.author)
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func createRequest(with queries: [URLQueryItem]) -> URLRequest? {
        guard var components = URLComponents(string: NEWS_FEED_API_DOMAIN) else {
            return nil
        }
        components.queryItems = queries
        components.queryItems?.append(URLQueryItem(name: "apiKey", value: NEWS_FEED_API_KEY))
        
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}
