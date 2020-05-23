//
//  ImageService.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class ImageService<C: Cache>: CachedWebervice<UIImage, C>
where C.V == Data, C.K == String {
    
    override func decodeCache(raw: C.V?) throws -> UIImage? {
        if let data = raw {
            return UIImage(data: data)
        }
        return nil
    }
    
    override func encodeCache(value: UIImage?) throws -> C.V? {
        if let data = value {
            return data.jpegData(compressionQuality: 1.0)
        }
        return nil
    }
    
    override func cacheKey(for url: URL) -> C.K {
        return url.absoluteString.sha1()
    }
}

class UIImageService<C: Cache>: CachedWebervice<UIImage, C>
where C.V == UIImage, C.K == String {
    
    override func decodeCache(raw: UIImage?) throws -> UIImage? {
        return raw
    }
    
    override func encodeCache(value: UIImage?) throws -> UIImage? {
        return value
    }
    
    override func cacheKey(for url: URL) -> C.K {
        return url.absoluteString.sha1()
    }
}
