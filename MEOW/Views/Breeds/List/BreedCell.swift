//
//  BreedCell.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 18.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class BreedCell: UICollectionViewCell {
    
    static let reuseID = String(describing: BreedCell.self)
    
    let viewModel = BreedCellViewModel()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: RoundImage!
    
    private var breed: Breed?
    
    let gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGradient()
    }
    
    func setGradient() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        gradient.frame = bounds
        gradient.colors = [UIColor(named: "light shadow")!.cgColor, UIColor(named: "light shadow")!.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
    
    func setGradientForBreed(_ breed: Breed) {
        let c1 = UIColor.random(seed: breed.name.djb2hash + 55).cgColor
        let c2 = UIColor.random(seed: breed.name.djb2hash - 55).cgColor
        gradient.colors = [c1, c2]
        gradient.colors = [ UIColor(named: "light shadow")!.cgColor,
                            UIColor.systemBackground.withAlphaComponent(0.2).cgColor,
                            UIColor(named: "light shadow")!.cgColor]
        
        gradient.startPoint = .random(seed: breed.name.djb2hash + 55)
        gradient.endPoint = .random(seed: breed.name.djb2hash - 55)
        
        let newStart = CGPoint(
            x: 2 * gradient.startPoint.x - gradient.endPoint.x,
            y: 2 * gradient.startPoint.x - gradient.endPoint.x)
        
        let animation1 = CABasicAnimation(keyPath: "startPoint")
        animation1.fromValue = gradient.startPoint
        animation1.toValue = newStart
        animation1.duration = 10.0
        animation1.autoreverses = true
        animation1.repeatCount = Float.infinity
        gradient.removeAnimation(forKey: "startPoint")
        
        let animation2 = CABasicAnimation(keyPath: "endPoint")
        animation2.fromValue = gradient.endPoint
        animation2.toValue = gradient.startPoint
        animation2.duration = 10.0
        animation2.autoreverses = true
        animation2.repeatCount = Float.infinity
        gradient.removeAnimation(forKey: "endPoint")
        
        gradient.add(animation1, forKey: nil)
        gradient.add(animation2, forKey: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setGradientForBreed(breed!)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let breed = breed {
            viewModel.cancel(breed: breed)
        }
        imageView.setup()
    }
    
    func configure(_ breed: Breed) {
        setGradientForBreed(breed)
        self.breed = breed
        label.text = "\(breed.name)"
        
        viewModel.fetch(breed: breed) { [weak self] image in
            guard let image = image else { return }
            guard let size = self?.imageView.frame.size else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                let resized = image.resizeFillImage(for: size)
                DispatchQueue.main.async {
                    self?.imageView.image = resized
                }
            }
        }
    }
}
