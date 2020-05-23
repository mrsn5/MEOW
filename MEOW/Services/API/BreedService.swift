//
//  BreedService.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class BreedService {
    
    private var dataService: Webservice<[Breed]>
    
    init(dataService: Webservice<[Breed]>) {
        self.dataService = dataService
    }
    
    func fetch(
        handler: @escaping (Result<[Breed]?, ServiceError>) -> ()
    ) {
        guard let url = breedComponents().url else {
            handler(.failure(.network(description: "Cannot create url")))
            return
        }
        dataService.load(with: url, decode: CodableCoder.decode(from:), handler: handler)
    }
}

// MARK: - Cat API
extension BreedService {
    func breedComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = TheCatAPI.scheme
        components.host = TheCatAPI.host
        components.path = TheCatAPI.path + "/breeds"
        
        return components
    }
}

