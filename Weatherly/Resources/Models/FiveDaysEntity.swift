//
//  WeekEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 23.07.2022.
//

import UIKit
import RealmSwift
import Realm

// MARK: - MainClass
struct MainWeatherInformation: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Weather
@objcMembers class Weather: Object, Decodable {
    dynamic var identifire: Int = 0
    dynamic var icon: String?
    @objc private dynamic var weatherDescriptionRawValue: String?
    
    var weatherDescription: Description? {
        guard let descriptionRawValue = weatherDescriptionRawValue else { return nil }
        return Description(rawValue: descriptionRawValue)
    }
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
        case identifire = "id"
    }
    
    init(identifire: Int, weatherDescription: Description? = nil, icon: String) {
        self.identifire = identifire
        self.weatherDescriptionRawValue = weatherDescription?.rawValue
        self.icon = icon
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifire = try container.decode(Int.self, forKey: .identifire)
        weatherDescriptionRawValue = try? container.decode(Description.self, forKey: .weatherDescription).rawValue
        icon = try? container.decode(String.self, forKey: .icon)
        
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

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
    
    func icon(isDayTime: Bool) -> UIImage? {
        switch self {
        case .brokenClouds, .fewClouds, .overcastClouds, .scatteredClouds:
            return isDayTime ? R.image.ic_white_day_cloudy() : R.image.ic_white_night_cloudy()
        case .clearSky:
            return isDayTime ? R.image.ic_white_day_bright() : R.image.ic_white_night_bright()
        case .lightRain:
            return isDayTime ? R.image.ic_white_day_rain() : R.image.ic_white_night_rain()
        case .moderateRain:
            return isDayTime ? R.image.ic_white_day_thunder() : R.image.ic_white_night_thunder()
        }
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
