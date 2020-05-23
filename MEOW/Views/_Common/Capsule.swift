//
//  Capsule.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 17.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class Capsule: UIView {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addCapsule()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCapsule()
    }

    func addCapsule() {
        backgroundColor = UIColor(named: "primary")
        self.layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        
    }
    
    
}
