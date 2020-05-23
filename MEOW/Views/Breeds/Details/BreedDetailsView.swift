//
//  BreedDetailsVIew.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 18.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class BreedDetailsView: UIViewController {

    
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var images: [UIImage] = []
    private var breed: Breed!
    
    private var viewModel: GalleryViewModel!
    
    init(breed: Breed) {
        super.init(nibName: String(describing: Self.self), bundle: nil)
        self.breed = breed
        imageView.image = UIImage.makeImage(from: UIColor(named: "light shadow") ?? UIColor.systemBackground)
        viewModel =  GalleryViewModel() { indexes in
            
        }
        viewModel.fetch()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
