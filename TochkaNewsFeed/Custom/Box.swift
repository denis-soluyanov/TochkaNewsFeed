//
//  Box.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

final class Box<T> {
    typealias Observer = (T) -> Void
    
    var observer: Observer?
    
    var value: T {
        didSet { observer?(value) }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(observer: @escaping Observer) {
        self.observer = observer
        observer(value)
    }
}
