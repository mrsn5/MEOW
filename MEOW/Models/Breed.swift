//
//  Breed.swift
//  CatTest
//
//  Created by San Byn Nguyen on 08.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

// MARK: - Breed
struct Breed: Codable, Identifiable, Hashable {
    static func == (lhs: Breed, rhs: Breed) -> Bool {
        return lhs.id == rhs.id
    }
    
    let adaptability, affectionLevel: Int?
    let altNames: String?
    let cfaURL: String?
    let childFriendly: Int?
    let countryCode, countryCodes, breedResponseDescription: String?
    let dogFriendly, energyLevel, experimental, grooming: Int?
    let hairless, healthIssues, hypoallergenic: Int?
    let id: String
    let indoor, intelligence: Int?
    let lifeSpan: String?
    let name: String
    let natural: Int?
    let origin: String?
    let rare, rex, sheddingLevel, shortLegs: Int?
    let socialNeeds, strangerFriendly, suppressedTail: Int?
    let temperament: String?
    let vcahospitalsURL: String?
    let vetstreetURL: String?
    let vocalisation: Int?
    let weight: Weight?
    let wikipediaURL: String?

    enum CodingKeys: String, CodingKey {
        case adaptability
        case affectionLevel = "affection_level"
        case altNames = "alt_names"
        case cfaURL = "cfa_url"
        case childFriendly = "child_friendly"
        case countryCode = "country_code"
        case countryCodes = "country_codes"
        case breedResponseDescription = "description"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case experimental, grooming, hairless
        case healthIssues = "health_issues"
        case hypoallergenic, id, indoor, intelligence
        case lifeSpan = "life_span"
        case name, natural, origin, rare, rex
        case sheddingLevel = "shedding_level"
        case shortLegs = "short_legs"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case suppressedTail = "suppressed_tail"
        case temperament
        case vcahospitalsURL = "vcahospitals_url"
        case vetstreetURL = "vetstreet_url"
        case vocalisation, weight
        case wikipediaURL = "wikipedia_url"
    }
}

// MARK: - Weight
struct Weight: Codable, Hashable {
    let imperial, metric: String?
}
