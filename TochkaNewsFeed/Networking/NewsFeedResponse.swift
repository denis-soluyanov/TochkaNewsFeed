//
//  NewsResponse.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import Foundation

struct NewsFeedResponse: Decodable {
    let status       : String
    let totalResults : Int
    let articles     : [ArticleResponse]
}

struct ArticleResponse: Decodable {
    let source      : Source?
    let author      : String?
    let title       : String
    let description : String?
    let url         : String
    let urlToImage  : String?
    let publishedAt : String
    let content     : String?
}

struct Source: Decodable {
    let id   : String?
    let name : String
}

struct NewsFeedErrorResponse: Decodable {
    let status  : String?
    let code    : String?
    let message : String?
}

extension NewsFeedErrorResponse: CustomDebugStringConvertible {
    var debugDescription: String {
        guard let status = status, let code = code, let message = message else {
              return "Description anavailable"
        }
        return "Status: \(status); code: \(code); message: \(message)"
    }
}
