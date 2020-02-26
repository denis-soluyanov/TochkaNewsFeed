//
//  URLRequestExtension.swift
//  TochkaNewsFeed
//
//  Created by den on 26.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import Foundation

extension URLRequest {
    
    init?(domain: String, queries: [URLQueryItem]?) {
        guard var components = URLComponents(string: domain) else { return nil }
        
        components.queryItems = queries
        
        guard let url = components.url else { return nil }
        
        self = URLRequest(url: url)
    }
}
