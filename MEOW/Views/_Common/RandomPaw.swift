//
//  RandomPaw.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class RandomPaw: UIImageView {

    override func awakeFromNib() {
        let pawType = Int.random(in: 1...4)
        image = UIImage(named: "paw\(pawType)")
    }

}
