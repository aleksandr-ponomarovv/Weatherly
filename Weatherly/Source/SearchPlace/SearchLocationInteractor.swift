//   
//  SearchLocationInteractor.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

protocol SearchLocationInteractorType {
    var locations: [Location] { get }
    
    func findLocations(text: String, completion: @escaping () -> Void)
    func save(location: Location)
}

class SearchLocationInteractor: SearchLocationInteractorType {
    
    private let locationManager = LocationManager.shared
    private let realmManager = RealmManager.shared
    
    // MARK: - Protocol property
    var locations: [Location] = []
    
    init() {}
    
    // MARK: - Protocol methods
    func findLocations(text: String, completion: @escaping () -> Void) {
        locationManager.findLocations(text: text) { [weak self] locations in
            guard let self = self else { return }
            
            self.locations = locations
            completion()
        }
    }
    
    func save(location: Location) {
        realmManager.addOrUpdate(object: location)
    }
}
