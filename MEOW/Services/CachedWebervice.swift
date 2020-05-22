//
//  CachedWebervice.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

enum CachePolicy {
    case loadCacheAndUpdate
    case loadCacheElseLoad
    case ignoreCache
}

class CachedWebervice<V, C: Cache>: Webservice<V> {
    
    private var cacheService: CacheService<V, C>
    private var policy: CachePolicy
    
    init(cache: C, policy: CachePolicy, session: URLSession = .shared) {
        self.cacheService = CacheService(cache: cache)
        self.policy = policy
        super.init(session: session)
    }
    
    override func load(
        with url: URL,
        decode: @escaping ((Data?, URLResponse?)) -> V,
        handler: @escaping (Result<V, ServiceError>) -> ())
    {
        switch policy {
        case .ignoreCache:
            ignoreCache(with: url, decode: decode, handler: handler)
        case .loadCacheElseLoad:
            loadCacheElseLoad(with: url, decode: decode, handler: handler)
        default:
            loadCacheAndUpdate(with: url, decode: decode, handler: handler)
        }
    }
    
    private func loadCacheAndUpdate(
        with url: URL,
        decode: @escaping ((Data?, URLResponse?)) -> V,
        handler: @escaping (Result<V, ServiceError>) -> ())
    {
        cacheService.load(with: cacheKey(for: url), decode: decodeCache(raw:)) { result in
            if case .success(let data) = result {
                handler(.success(data))
            }
            super.load(with: url, decode: decode, handler: handler)
        }
    }
    
    private func loadCacheElseLoad(
        with url: URL,
        decode: @escaping ((Data?, URLResponse?)) -> V,
        handler: @escaping (Result<V, ServiceError>) -> ())
    {
        cacheService.load(with: cacheKey(for: url), decode: decodeCache(raw:)) { result in
            if case .success(let data) = result {
                handler(.success(data))
                return
            }
            super.load(with: url, decode: decode, handler: handler)
        }
    }
    
    private func ignoreCache(
        with url: URL,
        decode: @escaping ((Data?, URLResponse?)) -> V,
        handler: @escaping (Result<V, ServiceError>) -> ())
    {
        super.load(with: url, decode: decode, handler: handler)
    }
    
    func decodeCache(raw: C.V?) -> V {
        fatalError("decodeCache(raw:) has not been implemented")
    }
    
    func cacheKey(for url: URL) -> C.K {
        
        fatalError("cacheKey(url:) has not been implemented")
    }
}
