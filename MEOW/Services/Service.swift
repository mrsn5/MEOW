//
//  Service.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

protocol LoadService {
    associatedtype K
    associatedtype V
    associatedtype R
    
    func load(with key: K,
              decode: @escaping (R?) throws -> V?,
              handler: @escaping (Result<V?, ServiceError>) -> ())
}

protocol SaveService {
    associatedtype K
    associatedtype V
    associatedtype R
    
    func save(_ data: V?,
              with key: K,
              encode: @escaping (V?) throws -> R?,
              completiom: ((Result<R?, ServiceError>) -> ())?)
}


enum ServiceError: Error {
    case network(description: String)
    case decoding(description: String)
    case encoding(description: String)
}
