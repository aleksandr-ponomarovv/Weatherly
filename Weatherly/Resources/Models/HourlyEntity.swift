//
//  HourlyEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import UIKit
import RealmSwift
import Realm

// MARK: - HourlyEntity
@objcMembers class HourlyEntity: Object, Decodable {
    dynamic var realmId: String = RealmKeyConstants.hourlyEntityId
    
    dynamic var timezone: String?
    dynamic var current: Current? = .init()
    var hourly = List<Hourly>()
    var daily = List<Daily>()
    
    enum CodingKeys: String, CodingKey {
        case timezone, current, hourly, daily
    }
    
    override static func primaryKey() -> String? {
        return RealmKeyConstants.primaryKey
    }
    
    init(timezone: String? = nil, current: Current? = nil, hourly: [Hourly], daily: [Daily]) {
        self.timezone = timezone
        self.current = current
        let hourlyList = List<Hourly>()
        let dailyList = List<Daily>()
        hourlyList.append(objectsIn: hourly)
        dailyList.append(objectsIn: daily)
        self.hourly = hourlyList
        self.daily = dailyList
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timezone = try? container.decode(String.self, forKey: .timezone)
        current = try? container.decode(Current.self, forKey: .current)
        do {
            let array = try container.decode([Hourly].self, forKey: .hourly)
            hourly.append(objectsIn: array)
        } catch {
            hourly = List<Hourly>()
        }
        do {
            let array = try container.decode([Daily].self, forKey: .daily)
            daily.append(objectsIn: array)
        } catch {
            daily = List<Daily>()
        }
        
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

protocol CurrentModel {
    var time: String { get }
    var temperature: String { get }
    var percentHumidity: String { get }
    var windSpeedMetersPerSecond: String { get }
    var icon: UIImage? { get }
}

// MARK: - Current
@objcMembers class Current: Object, CurrentModel, Decodable {
    dynamic var dateTime: Int = 0
    dynamic var sunrise: Int = 0
    dynamic var sunset: Int = 0
    dynamic var temp: Double = 0
    dynamic var feelsLike: Double = 0
    dynamic var pressure: Int = 0
    dynamic var humidity: Int = 0
    dynamic var dewPint: Double = 0
    dynamic var uvi: Double = 0
    dynamic var clouds: Double = 0
    dynamic var visibility: Double = 0
    dynamic var windSpeed: Double = 0
    var weather = List<Weather>()
    
    var time: String {
        dateTime.toCalendarDate()
    }
    
    var temperature: String {
        temp.toTemperature()
    }
    
    var percentHumidity: String {
        humidity.toPercentHumidity()
    }
    
    var windSpeedMetersPerSecond: String {
        windSpeed.toSpeed()
    }
    
    var icon: UIImage? {
        guard let weatherDescription = weather.first?.weatherDescription,
              let isNightTime = dateTime.toHours().isDayTime else { return nil }
        return weatherDescription.icon(isDayTime: isNightTime)
    }
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case sunrise
        case sunset
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPint = "dew_point"
        case uvi
        case clouds
        case visibility
        case windSpeed = "wind_speed"
        case weather
    }
    
    init(dateTime: Int,
         sunrise: Int,
         sunset: Int,
         temp: Double,
         feelsLike: Double,
         pressure: Int,
         humidity: Int,
         dewPint: Double,
         uvi: Double,
         clouds: Double,
         visibility: Double,
         windSpeed: Double,
         weather: [Weather]) {
        self.dateTime = dateTime
        self.sunrise = sunrise
        self.sunset = sunset
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPint = dewPint
        self.uvi = uvi
        self.clouds = clouds
        self.visibility = visibility
        self.windSpeed = windSpeed
        let weatherList = List<Weather>()
        weatherList.append(objectsIn: weather)
        self.weather = weatherList
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dateTime = try container.decode(Int.self, forKey: .dateTime)
        sunrise = try container.decode(Int.self, forKey: .sunrise)
        sunset = try container.decode(Int.self, forKey: .sunset)
        temp = try container.decode(Double.self, forKey: .temp)
        feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        dewPint = try container.decode(Double.self, forKey: .dewPint)
        uvi = try container.decode(Double.self, forKey: .uvi)
        clouds = try container.decode(Double.self, forKey: .clouds)
        visibility = try container.decode(Double.self, forKey: .visibility)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        do {
            let array = try container.decode([Weather].self, forKey: .weather)
            weather.append(objectsIn: array)
        } catch {
            weather = List<Weather>()
        }
        
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

@objcMembers class Hourly: Object, HourCellModel, Decodable {
    dynamic var dateTime: Int = 0
    dynamic var temp: Double = 0
    dynamic var humidity: Int = 0
    var weather = List<Weather>()
    dynamic var pop: Double = 0
    
    var time: String {
        dateTime.toHours()
    }
    
    var temperature: String {
        temp.toTemperature()
    }
    
    var icon: UIImage? {
        guard let weatherDescription = weather.first?.weatherDescription,
              let isNightTime = time.isDayTime else { return nil }
        return weatherDescription.icon(isDayTime: isNightTime)
    }
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity, weather, pop
        case dateTime = "dt"
    }
    
    init(dateTime: Int, temp: Double, humidity: Int, weather: [Weather], pop: Double) {
        self.dateTime = dateTime
        self.temp = temp
        self.humidity = humidity
        let weatherList = List<Weather>()
        weatherList.append(objectsIn: weather)
        self.weather = weatherList
        self.pop = pop
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dateTime = try container.decode(Int.self, forKey: .dateTime)
        temp = try container.decode(Double.self, forKey: .temp)
        humidity = try container.decode(Int.self, forKey: .humidity)
        pop = try container.decode(Double.self, forKey: .pop)
        do {
            let array = try container.decode([Weather].self, forKey: .weather)
            weather.append(objectsIn: array)
        } catch {
            weather = List<Weather>()
        }
        
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

@objcMembers class Daily: Object, DayCellModel, Decodable {
    dynamic var dateTime: Int = 0
    dynamic var temp: Temp? = .init()
    dynamic var humidity: Int = 0
    var weather = List<Weather>()
    dynamic var pop: Double = 0
    
    var dayOfWeek: String {
        dateTime.toDay()
    }
    
    var temperature: String {
        temp?.all ?? ""
    }
    
    var icon: UIImage? {
        guard let weather = Array(weather).first,
              let weatherDescription = weather.weatherDescription else { return nil }
        
        return weatherDescription.icon(isDayTime: true)
    }
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity, weather, pop
        case dateTime = "dt"
    }
    
    init(dateTime: Int, temp: Temp? = nil, humidity: Int, weather: [Weather], pop: Double) {
        self.dateTime = dateTime
        self.temp = temp
        self.humidity = humidity
        let weatherList = List<Weather>()
        weatherList.append(objectsIn: weather)
        self.weather = weatherList
        self.pop = pop
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dateTime = try container.decode(Int.self, forKey: .dateTime)
        temp = try? container.decode(Temp.self, forKey: .temp)
        humidity = try container.decode(Int.self, forKey: .humidity)
        pop = try container.decode(Double.self, forKey: .pop)
        do {
            let array = try container.decode([Weather].self, forKey: .weather)
            weather.append(objectsIn: array)
        } catch {
            weather = List<Weather>()
        }
        
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

@objcMembers class Temp: Object, Codable {
    dynamic var min: Double = 0
    dynamic var max: Double = 0
    dynamic var night: Double = 0
    
    var all: String {
        let minTemperature = min.toTemperature()
        let maxTemperature = max.toTemperature()
        return "\(maxTemperature) / \(minTemperature)"
    }
    
    enum CodingKeys: String, CodingKey {
        case min, max, night
    }
    
    init(min: Double, max: Double, night: Double) {
        self.min = min
        self.max = max
        self.night = night
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        min = try container.decode(Double.self, forKey: .min)
        max = try container.decode(Double.self, forKey: .max)
        night = try container.decode(Double.self, forKey: .night)
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
