//
//  BreedCellViewModel.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit


class BreedCellViewModel: ImageViewModel<FileStorage> {
    
    private var service = CatImageService(dataService: CodableService(cache: FileStorage.shared, policy: .loadCacheElseLoad))
    
    private(set) var catImage: CatImage?
    
    init() {
        super.init(service: ImageService(cache: FileStorage.shared, policy: .loadCacheElseLoad))
    }
    
    func fetch(breed: Breed, handler: @escaping (UIImage?) -> ()) {
        service.fetch(count: 1, breedId: breed.id, order: "ASC") { [weak self] res in
            if case .success(let catImages) = res {
                guard let catImages = catImages, catImages.count > 0 else { return }
                self?.catImage = catImages[0]
                self?.load(string: catImages[0].url, handler: handler)
            } else {
                handler(nil)
            }
        }
    }
    
    func cancel(breed: Breed) {
        service.cancel(count: 1, breedId: breed.id, order: "ASC", handler: nil)
        if let catImage = catImage {
            self.cancel(string: catImage.url)
        }
    }
}
