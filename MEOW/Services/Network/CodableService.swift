//
//  CodableService.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class CodableService<V: Codable, C: Cache>: CachedWebervice<V, C>
where C.V == Data, C.K == String {
    
    override func decodeCache(raw: C.V?) throws -> V? {
        if let data = raw {
            return try JSONDecoder().decode(V.self, from: data)
        }
        return nil
    }
    
    override func cacheKey(for url: URL) -> C.K {
        return url.absoluteString
    }
}
