//
//  GalleryFeedCell.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 17.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class GalleryFeedCell: UICollectionViewCell {
    static let reuseID = String(describing: GalleryFeedCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    
    private let imageViewModel = ImageViewModel<ImageRAMCache>(service: UIImageService(cache: ImageRAMCache.shared, policy: .loadCacheElseLoad))
    private var catImage: CatImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.makeImage(from: UIColor(named: "light shadow") ?? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.3))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let image = catImage else { return }
        imageViewModel.cancel(string: image.url)
        imageView.image = UIImage.makeImage(from: UIColor(named: "light shadow") ?? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.3))
    }
    
    func configure(_ catImage: CatImage?) {
        guard let image = catImage else { return }
        self.catImage = image
        
        
        imageViewModel.load(string: catImage!.url) { [weak self] image in
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
