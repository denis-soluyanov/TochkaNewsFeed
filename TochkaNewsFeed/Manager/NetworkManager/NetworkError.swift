//
//  NetworkError.swift
//  TochkaNewsFeed
//
//  Created by den on 26.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import Foundation

enum NetworkError {
    case requestError(_ value: Error)
    case responseTypeError
    case dataError
    case responseCode(_ value: Int)
}

extension NetworkError {
    var description: String {
        switch self {
        case let .requestError(value): return "Request error: \(value.localizedDescription)"
        case     .responseTypeError  : return "Response doesn't comply to HTTP protocol"
        case     .dataError          : return "No data available in response body"
        case let .responseCode(value): return "HTTP code: \(value)"
        }
    }
}
