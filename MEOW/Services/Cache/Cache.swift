//
//  Cache.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

protocol Cache {
    associatedtype V
    associatedtype K
    
    subscript (key: K) -> V? {get set}
}
