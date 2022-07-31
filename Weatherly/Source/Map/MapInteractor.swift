//   
//  MapInteractor.swift
//  Weatherly
//
//  Created by Aleksandr on 30.07.2022.
//

import Realm
import RealmSwift

protocol MapInteractorType {
    var selectedLocation: Location? { get }
    
    func save(location: Location)
    func saveLocation(latitude: Double, longitude: Double)
    func startUpdatingLocation()
    func checkLocationPermission(completion: @escaping(Bool) -> Void)
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Location>>) -> Void)
}

class MapInteractor: MapInteractorType {
    
    private let locationManager = LocationManager.shared
    private let realmManager = RealmManager.shared
    private var notificationToken: NotificationToken?
    
    // MARK: - Protocol property
    var selectedLocation: Location? {
        return realmManager.getObject(primaryKey: RealmKeyConstants.locationId)
    }
    
    init(locationManagerDelegate: LocationManagerDelegate) {
        locationManager.delegate = locationManagerDelegate
    }
    
    // MARK: - Protocol methods
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func save(location: Location) {
        realmManager.addOrUpdate(object: location)
    }
    
    func saveLocation(latitude: Double, longitude: Double) {
        locationManager.getLocation(latitude: latitude, longitude: longitude) { [weak self] location in
            guard let self = self,
                  let location = location else { return }
            
            self.realmManager.addOrUpdate(object: location)
        }
    }
    
    func checkLocationPermission(completion: @escaping (Bool) -> Void) {
        locationManager.checkPermission(authorizedHandler: completion)
    }
    
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Location>>) -> Void) {
        notificationToken = realmManager.observeUpdateChanges(type: Location.self, completion)
    }
}
