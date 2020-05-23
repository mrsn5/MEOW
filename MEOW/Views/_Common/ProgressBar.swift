//
//  ProgressBar.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 18.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressBar: UIProgressView {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        //        transform = transform.scaledBy(x: 1, y: 4)
        layer.cornerRadius = 3
        clipsToBounds = true
        layer.sublayers![1].cornerRadius = 3
        subviews[1].clipsToBounds = true
    }
}
