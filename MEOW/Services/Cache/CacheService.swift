//
//  CacheService.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class CacheService<V, C: Cache>: LoadService, SaveService {

    var cache: C
    
    init(cache: C) {
        self.cache = cache
    }
    
    func load(with key: C.K,
              decode: @escaping (C.V?) throws -> V?,
              handler: @escaping (Result<V?, ServiceError>) -> ())
    {
        do {
            handler(.success(try decode(cache[key])))
        } catch {
            handler(.failure(.decoding(description: error.localizedDescription)))
        }
    }
    
    func save(_ data: V?,
              with key: C.K,
              encode: @escaping (V?) throws -> C.V?,
              completiom: ((Result<C.V?, ServiceError>) -> ())?)
    {
        do {
            let encoded = try encode(data)
            cache[key] = encoded
            completiom?(.success(encoded))
        } catch {
            completiom?(.failure(.encoding(description: error.localizedDescription)))
        }
    }
}
