//
//  ImageViewModel.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class ImageViewModel<C: Cache>{
    
    private var service: CachedWebervice<UIImage, C>
    
    init<CT: Cache>(service: ImageService<CT>) where C.K == CT.K, C.V == CT.V {
        self.service = service as! ImageService<C>
    }
    
    init<CT: Cache>(service: UIImageService<CT>) where C.K == CT.K, C.V == CT.V {
        self.service = service as! UIImageService<C>
    }
    
    func load(string: String, handler: @escaping (UIImage?)->()) {
        guard let url = URL(string: string) else { return }
        service.load(with: url, decode: UIImageDecoder.decode(from:)) { result in
            DispatchQueue.main.async {
                if case .success(let image) = result {
                    handler(image)
                }
                handler(nil)
            }
        }
    }
    
    func cancel(string: String) {
        guard let url = URL(string: string) else { return }
        service.cancel(url: url)
    }
}
