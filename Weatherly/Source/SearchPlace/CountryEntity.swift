//
//  CountryEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

// MARK: - CountryEntity
struct CountryEntity: Codable {
    let name: String
    let regions: [Region]
}

// MARK: - Region
struct Region: Codable {
    let name: String
    let cities: [City]
}

// MARK: - City
struct City: Codable {
    let name, lat, log: String
    
    enum CodingKeys: String, CodingKey {
        case name, lat
        case log = "lng"
    }
}
