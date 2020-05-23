//
//  BreedCellViewModel.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit


class BreedDetailsViewModel: ImageViewModel<FileStorage> {
    
    private var service = CatImageService(dataService: CodableService(cache: FileStorage.shared, policy: .loadCacheElseLoad))
    
    private(set) var catImages: [CatImage] = []
    private(set) var images: [UIImage] = []
    private var lastCatImageLoaded: String?
    
    init() {
        super.init(service: ImageService(cache: FileStorage.shared, policy: .loadCacheElseLoad))
    }
    
    func fetch(breed: Breed, handler: @escaping ([CatImage]?) -> ()) {
        service.fetch(count: 100, breedId: breed.id, order: "ASC") { [weak self] res in
            if case .success(let catImages) = res {
                guard let catImages = catImages, let self = self else { return }
                self.catImages = catImages
                handler(self.catImages)
            } else {
                handler(nil)
            }
        }
    }
    
    override func load(string: String, handler: @escaping (UIImage?) -> ()) {
        super.load(string: string, handler: handler)
        lastCatImageLoaded = string
    }
    
    func cancel(breed: Breed) {
        service.cancel(count: 1, breedId: breed.id, order: "ASC", handler: nil)
        for ci in catImages {
            self.cancel(string: ci.url)
        }
        catImages.removeAll()
    }
    
    func cancelLast() {
        guard let lastCatImageLoaded = lastCatImageLoaded else { return }
        super.cancel(string: lastCatImageLoaded)
    }
}
