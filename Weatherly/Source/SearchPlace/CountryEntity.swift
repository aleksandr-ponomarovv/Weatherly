//
//  CountryEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import RealmSwift
import Realm

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
@objcMembers class City: Object, Codable {
    dynamic var realmId: String = RealmKeyConstants.selectedCityId

    dynamic var name: String?
    dynamic var lat: String?
    dynamic var lon: String?
    
    enum CodingKeys: String, CodingKey {
        case name, lat
        case lon = "lng"
    }
    
    override static func primaryKey() -> String? {
        return RealmKeyConstants.primaryKey
    }
    
    convenience init(name: String, lat: String, lon: String) {
        self.init()
        self.name = name
        self.lat = lat
        self.lon = lon
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        lat = (try? container.decode(String.self, forKey: .lat)) ?? ""
        lon = (try? container.decode(String.self, forKey: .lon)) ?? ""
        super.init()
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
