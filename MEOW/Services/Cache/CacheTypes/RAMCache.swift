//
//  RAMCache.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class RAMCache<V: AnyObject>: Cache {
    let cache = NSCache<NSString, V>()
    
    subscript(key: String) -> V? {
        get {
            return cache.object(forKey: key as NSString)
        }
        set(newValue) {
            if let value = newValue {
                cache.setObject(value, forKey: key as NSString)
            } else {
                cache.removeObject(forKey: key as NSString)
            }
        }
    }
}

class ImageRAMCache: RAMCache<UIImage> {
    static let shared = ImageRAMCache()
    
    init(cacheCountLimit: Int = 50) {
        super.init()
        self.cache.countLimit = cacheCountLimit
    }
}
