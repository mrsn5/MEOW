//
//  FileStorage.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class FileStorage: Cache {
    
    static var shared = FileStorage()
    
    
    let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

    subscript(key: String) -> Data? {
        get {
            let url = baseURL.appendingPathComponent(key)
            return try? Data(contentsOf: url)
        }
        set {
            let url = baseURL.appendingPathComponent(key)
            if let data = newValue {
                _ = try? data.write(to: url)
            } else {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }
}
