//
//  CatImageService.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class CatImageService {
    
    private var dataService: Webservice<[CatImage]>
    
    init(dataService: Webservice<[CatImage]>) {
        self.dataService = dataService
    }
    
    func fetch(
        count: Int = 18,
        categoryIds: [Int] = [],
        breedId: String = "",
        order: String = "RANDOM",
        handler: @escaping (Result<[CatImage]?, ServiceError>) -> ()
    ) {
        guard let url = galleryComponents(count: count, categoryIds: categoryIds, breedId: breedId, order: order).url else {
            handler(.failure(.network(description: "Cannot create url")))
            return
        }
        
        dataService.load(with: url, decode: CodableCoder.decode(from:), handler: handler)
    }
    
    func cancel(
        count: Int = 18,
        categoryIds: [Int] = [],
        breedId: String = "",
        order: String = "RANDOM",
        handler: ((Result<[CatImage]?, ServiceError>) -> ())?
    ) {
        guard let url = galleryComponents(count: count, categoryIds: categoryIds, breedId: breedId, order: order).url else { return }
        dataService.cancel(url: url)
    }
}

// MARK: - Cat API
extension CatImageService {
    func galleryComponents(count: Int, categoryIds: [Int], breedId: String, order: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = TheCatAPI.scheme
        components.host = TheCatAPI.host
        components.path = TheCatAPI.path + "/images/search"
        components.queryItems = [
           URLQueryItem(name: "limit", value: "18"),
           URLQueryItem(name: "size", value: "thumb"),
           URLQueryItem(name: "breed_id", value: breedId),
           URLQueryItem(name: "order", value: order),
           URLQueryItem(name: "category_ids", value: categoryIds.map { String($0) }.joined(separator: ",") )
        ]
        return components
    }
}
