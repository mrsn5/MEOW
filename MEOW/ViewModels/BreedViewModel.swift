//
//  BreedViewModel.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation
import os.log

class BreedViewModel {
    private let service: BreedService = BreedService(dataService: CodableService(cache: FileStorage.shared, policy: .loadCacheElseLoad))
    private var updateHandler: () -> ()
    private(set) var dataSource: [Breed] = []
    
    init(updateHandler: @escaping () -> ()) {
        self.updateHandler = updateHandler
    }
    
    func fetch() {
        service.fetch { result in
            if case .success(let data) = result {
                guard let data = data else { return }
                self.dataSource = data
                
                DispatchQueue.main.async {
                    self.updateHandler()
                }
            }
            
            if case .failure(let error) = result {
                OSLog.defaultError(error: error)
            }
        }
    }
}
