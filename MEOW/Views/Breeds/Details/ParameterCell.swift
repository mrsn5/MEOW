//
//  ParameterCell.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class ParameterCell: UICollectionViewCell {
    
    static let reuseID = String(describing: ParameterCell.self)
    
    @IBOutlet weak var parameterLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(text: String, value: Double) {
        parameterLabel.text = text
        progressBar.progress = Float(value)
    }

}
