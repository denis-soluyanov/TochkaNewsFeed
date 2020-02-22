//
//  NetworkManager.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import Foundation


typealias JSONTask = URLSessionDataTask
typealias Completion = (Data?, URLResponse?, Error?) -> Void


protocol NetworkManager {
    func jsonTask(request: URLRequest, completion: (Data?, URLResponse?, Error?) -> Void) -> JSONTask
    
    func createRequest(with queries: [URLQueryItem]) -> URLRequest?
}
