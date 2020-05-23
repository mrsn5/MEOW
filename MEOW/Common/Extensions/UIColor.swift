//
//  UIColor.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func random(seed: Int) -> UIColor {
        let seed = abs(seed)
        let r = [
            (CGFloat(seed / 2 % 50) + 180) / 255.0,
            (CGFloat(seed / 5 % 50) + 180) / 255.0,
            (CGFloat(seed / 11 % 30) + 140) / 255.0
        ]
        let i = abs(seed % 3)
        return UIColor(red: r[i], green: r[(i + 1) % 3], blue: r[(i + 2) % 3], alpha: 1.0)
    }
    
}
