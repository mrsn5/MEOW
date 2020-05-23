//
//  GalleryViewModel.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation
import os.lock

class GalleryViewModel {
    
    private var service = CatImageService(dataService: Webservice())
    private var updateHandler: (([IndexPath]) -> ())?
    private(set) var dataSource: [CatImage]
    private var isLoading = false
    
    init(dataSource: [CatImage] = [], updateHandler: (([IndexPath]) -> ())? = nil) {
        self.dataSource = dataSource
        self.updateHandler = updateHandler
    }
    
    init(service: CatImageService) {
        self.service = service
        self.dataSource = []
    }
    
    func fetch(categoryIds: [Int] = []) {
        if isLoading { return }
        isLoading = true
        
        service.fetch(categoryIds: categoryIds) { [weak self] result in
            guard let self = self else { return }
            
            if case .success(let data) = result {
                guard let data = data else { return }
                self.dataSource.append(contentsOf: data)
                let startIndex = self.dataSource.count - data.count
                let endIndex = self.dataSource.count
                
                DispatchQueue.main.async {
                    self.updateHandler?((startIndex..<endIndex)
                        .map { IndexPath(row: $0, section: 0) })
                }
            }
            
            if case .failure(let error) = result {
                OSLog.defaultError(error: error)
            }
            
            self.isLoading = false
        }
    }
    
}
