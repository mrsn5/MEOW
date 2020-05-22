//
//  CacheService.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class CacheService<V, C: Cache>: LoadService, SaveService {
    typealias K = C.K
    typealias V = V
    typealias R = C.V?

    var cache: C
    
    init(cache: C) {
        self.cache = cache
    }
    
    func load(with key: C.K,
              decode: @escaping (C.V?) -> V,
              handler: @escaping (Result<V, ServiceError>) -> ())
    {
        handler(.success(decode(cache[key])))
    }
    
    func save(_ data: V,
              with key: C.K,
              encode: @escaping (V) -> C.V?)
    {
        cache[key] = encode(data)
    }
}
