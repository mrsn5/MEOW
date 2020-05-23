//
//  CatImage.swift
//  CatTest
//
//  Created by San Byn Nguyen on 13.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

// MARK: - CatImage
struct CatImage: Codable, Identifiable, Hashable {

    let breeds: [Breed]?
    let height: Int?
    let id: String
    let url: String
    let width: Int?
    let categories: [Category]?
    
    
    static func == (lhs: CatImage, rhs: CatImage) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getHeight(from width: Int) -> Int {
        guard let w = self.width, let h = self.height else { return width * 3 / 4 }
        return width * h / w
    }
}

// MARK: - Category
struct Category: Codable, Hashable, Identifiable {
    let id: Int
    let name: String?
}
