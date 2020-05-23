//
//  CGPoint.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

extension CGPoint {
    static func random(seed: Int) -> CGPoint {
        return CGPoint(x: Double(seed / 3 % 100) / 100, y: Double(seed / 5 % 100) / 100)
    }
}
