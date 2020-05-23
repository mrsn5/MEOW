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
    let countryCode, countryCodes, breedDescription: String?
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

    func country() -> String {
        return "\(countryCode?.flag() ?? "") \(origin ?? "")"
    }
    
    func lifeSpanText() -> String? {
        if let lifespan = lifeSpan {
            return "\(lifespan) average life span"
        }
        return nil
    }
    
    func weightText() -> String? {
        if let weight = weight?.metric {
            return "\(weight) kgs"
        }
        return nil
    }
    
    func trueFacts() -> [String] {
        var facts: [String] = []
        if experimental ?? 0 > 0 { facts.append("experimental")}
        if hairless ?? 0 > 0 { facts.append("hairless")}
        if natural ?? 0 > 0 { facts.append("natural")}
        if rare ?? 0 > 0 { facts.append("rare")}
        if rex ?? 0 > 0 { facts.append("rex")}
        if suppressedTail ?? 0 > 0 { facts.append("suppressedtail")}
        if shortLegs ?? 0 > 0 { facts.append("shortlegs")}
        if hypoallergenic ?? 0 > 0 { facts.append("hypoallergenic")}
        return facts
    }
    
    func percentFacts() -> [String: Double] {
        var dict: [String: Double] = [:]
        dict["Adaptability"] = Double(adaptability ?? 0) / 5
        dict["Affection Level"] = Double(affectionLevel ?? 0) / 5
        dict["Child Friendly"] = Double(childFriendly ?? 0) / 5
        dict["Dog Friendly"] = Double(dogFriendly ?? 0) / 5
        dict["Energy Level"] = Double(energyLevel ?? 0) / 5
        dict["Grooming"] = Double(grooming ?? 0) / 5
        dict["Health Issues"] = Double(healthIssues ?? 0) / 5
        dict["Intelligence"] = Double(intelligence ?? 0) / 5
        dict["Shedding Level"] = Double(sheddingLevel ?? 0) / 5
        dict["Social Needs"] = Double(socialNeeds ?? 0) / 5
        dict["Stranger Friendly"] = Double(strangerFriendly ?? 0) / 5
        dict["Vocalisation"] = Double(vocalisation ?? 0) / 5
        return dict
    }
    
    enum CodingKeys: String, CodingKey {
        case adaptability
        case affectionLevel = "affection_level"
        case altNames = "alt_names"
        case cfaURL = "cfa_url"
        case childFriendly = "child_friendly"
        case countryCode = "country_code"
        case countryCodes = "country_codes"
        case breedDescription = "description"
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
