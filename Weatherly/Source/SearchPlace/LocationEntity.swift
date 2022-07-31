//
//  LocationEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import RealmSwift
import Realm
import CoreLocation

// MARK: - Location
@objcMembers class Location: Object {
    dynamic var realmId: String = RealmKeyConstants.locationId

    dynamic var name: String?
    dynamic var country: String?
    
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    override static func primaryKey() -> String? {
        return RealmKeyConstants.primaryKey
    }
    
    convenience init(name: String, country: String, latitude: Double, longitude: Double) {
        self.init()
        
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required override init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init()
    }
}
