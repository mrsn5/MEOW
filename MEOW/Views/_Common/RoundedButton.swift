//
//  RoundedButton.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 19.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 10
    }
    

}
