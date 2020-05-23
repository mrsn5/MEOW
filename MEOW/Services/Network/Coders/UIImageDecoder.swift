//
//  UIImageDecoder.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class UIImageDecoder {
    
    static func decode(from: (Data, URLResponse)?) -> UIImage? {
        guard let data = from else { return nil }
        
        if let httpResponse = data.1 as? HTTPURLResponse,
            let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
            
            if contentType == "image/gif" {
                return UIImage.gif(with: data.0)
            } else if contentType == "image/jpeg" || contentType == "image/png" {
                return UIImage(data: data.0)
            }
        }
        return nil
    }
}
