//
//  NewsFeedAPI.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import Foundation

let NEWS_FEED_API_DOMAIN = "http://newsapi.org/v2/everything"
let NEWS_FEED_API_KEY    = "26c3b0681dbb43dab2537ec57e08b13f"

enum NewsFeedAPI {
    /* Keywords or phrases to search for in the article title and body */
    case keyWords(value: String)
    
    /* Keywords or phrases to search for in the article title only */
    case keyWordsInTitle(value: String)
    
    /* The 2-letter ISO-639-1 code of the language you want to get headlines for */
    case language(value: NewsLanguage)
    
    /* The order to sort the articles in */
    case sortBy(value: SortOrder)
    
    /* The number of results to return per page */
    case pageSize(value: Int)
    
    /* Use this to page through the results */
    case page(value: Int)
}

enum NewsLanguage: String {
    case arabic       = "ar"
    case deutsch      = "de"
    case english      = "en"
    case spanish      = "es"
    case french       = "fr"
    case hebrew       = "he"
    case italian      = "it"
    case dutch        = "nl"
    case norwegian    = "no"
    case portuguese   = "pt"
    case russian      = "ru"
    case northernSami = "se"
    case chinese      = "zh"
}

enum SortOrder: String {
    case relevancy   = "relevancy"
    case popularity  = "popularity"
    case publishedAt = "publishedAt"
}

extension NewsFeedAPI {
    var urlQueryItem: URLQueryItem {
        
        switch self {
        case let .keyWords(value):
            return URLQueryItem(name: "q", value: value)
            
        case let .keyWordsInTitle(value):
            return URLQueryItem(name: "qInTitle", value: value)
            
        case let .language(value):
            return URLQueryItem(name: "language", value: String(value.rawValue))
            
        case let .sortBy(value):
            return URLQueryItem(name: "sortBy", value: String(value.rawValue))
            
        case let .pageSize(value):
            return URLQueryItem(name: "pageSize", value: String(value))
            
        case let .page(value):
            return URLQueryItem(name: "page", value: String(value))
        }
    }
}
