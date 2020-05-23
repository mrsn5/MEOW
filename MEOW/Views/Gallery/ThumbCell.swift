//
//  ThumbCell.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 16.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class ThumbCell: UICollectionViewCell {
    
    static let reuseID = String(describing: ThumbCell.self)
    private let imageViewModel = ImageViewModel<ImageRAMCache>(service: UIImageService(cache: ImageRAMCache.shared, policy: .loadCacheElseLoad))
    
    var imageView = UIImageView()
    var catImage: CatImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.autoresizesSubviews = true
        
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(named: "background")?.cgColor
        self.addSubview(imageView)
        self.backgroundColor = UIColor(named: "light shadow")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
        guard let image = catImage else { return }
        imageViewModel.cancel(string: image.url)
    }
    
    func configure(_ catImage: CatImage?) {
        guard let image = catImage else { return }
        self.catImage = image
        imageViewModel.load(string: image.url) { [weak self] image in
            guard let image = image else { return }
            self?.imageView.image = image
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        imageView.layer.borderColor = UIColor(named: "background")?.cgColor
        self.backgroundColor = UIColor(named: "light shadow")
    }
    
    
}
