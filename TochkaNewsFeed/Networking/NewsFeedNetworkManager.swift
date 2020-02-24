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
        return NewsFeedNetworkManager(apiKey: NEWS_FEED_API_KEY, domain: NEWS_FEED_API_DOMAIN)
    }()
    
    private init(apiKey: String, domain: String) {
        session = URLSession(configuration: URLSessionConfiguration.default)
        self.apiKey = apiKey
        self.domain = domain
    }
 
    func fetchNews(with queries: [NewsFeedAPI], completion: @escaping (NewsFeedResponse?) -> Void) {
        guard let request = createRequest(with: queries.map{ $0.urlQueryItem }) else {
            completion(nil)
            return
        }
        fetch(request: request) { jsonData in
            guard let jsonData = jsonData else { return }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsFeedResponse.self, from: jsonData)
                completion(newsResponse)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
}

private extension NewsFeedNetworkManager {
    
    func createRequest(with queries: [URLQueryItem]) -> URLRequest? {
        guard var components = URLComponents(string: NEWS_FEED_API_DOMAIN) else {
            return nil
        }
        components.queryItems = queries
        
        guard let url = components.url else { return nil }
        print(url)
        return URLRequest(url: url)
    }
    
    func fetch(request: URLRequest, completion: @escaping (Data?) -> Void) {
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                print("Response doesn't comply to HTTP protocol")
                completion(nil)
                return
            }
            guard response.statusCode == 200 else {
                print("response code: \(response.statusCode)")
                completion(nil)
                return
            }
            guard error == nil else {
                print("\(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let jsonData = data else {
                print("No data available in response body")
                completion(nil)
                return
            }
            completion(jsonData)
        }.resume()
    }
}
