//
//  RoundImage.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 21.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func setup() {
        image = UIImage.makeImage(from: UIColor.systemBackground)
        layer.borderWidth = 5
        layer.borderColor = UIColor(named: "background")?.cgColor
        layer.masksToBounds = false
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layer.borderColor = UIColor(named: "background")?.cgColor
        if image == nil {
            image = UIImage.makeImage(from: UIColor.systemBackground)
        }
    }
    
}

