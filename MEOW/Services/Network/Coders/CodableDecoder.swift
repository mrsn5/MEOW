//
//  CodableDecoder.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class CodableCoder {
    
    static func decode<V: Decodable>(from: (Data, URLResponse)?) throws -> V? {
        if let data = from?.0 {
            return try JSONDecoder().decode(V.self, from: data)
        }
        return nil
    }

}
