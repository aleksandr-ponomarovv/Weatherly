//   
//  ViperInteractor.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

protocol SearchPlaceInteractorType {
    var filteredCities: [City] { get }
    
    func filterCities(text: String)
}

class SearchPlaceInteractor: SearchPlaceInteractorType {
    
    private let countryEntity: CountryEntity?
    private let jsonReader = JsonReader()
    
    // MARK: - Protocol property
    var filteredCities: [City] = []
    
    var cities: [City] {
        let regions = countryEntity?.regions ?? []
        var cities: [City] = []
        regions.forEach { region in
            region.cities.forEach { city in
                cities.append(city)
            }
        }
        return cities
    }
    
    init() {
        self.countryEntity = jsonReader.readLocalFile(for: .uaCities)
        self.filteredCities = cities
    }
    
    // MARK: - Protocol methods
    func filterCities(text: String) {
        let allCities = cities
        if text.isEmpty {
            filteredCities = allCities
        } else {
            filteredCities = allCities.filter { $0.name?.contains(text) ?? false }
        }
    }
}
