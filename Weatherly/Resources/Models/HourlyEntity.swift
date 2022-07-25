//
//  HourlyEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import UIKit

// MARK: - HourlyEntity
struct HourlyEntity: Codable {
    let timezone: String
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

protocol CurrentModel {
    var time: String { get }
    var temperature: String { get }
    var percentHumidity: String { get }
    var windSpeedMetersPerSecond: String { get }
    var icon: UIImage? { get }
}

// MARK: - Current
struct Current: CurrentModel, Codable {
    let dateTime: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPint: Double
    let uvi: Double
    let clouds: Double
    let visibility: Double
    let windSpeed: Double
    let weather: [Weather]
    
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
}

struct Hourly: HourCellModel, Codable {
    let dateTime: Int
    let temp: Double
    let humidity: Int
    let weather: [Weather]
    let pop: Double
    
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
}

struct Daily: DayCellModel, Codable {
    let dateTime: Int
    let temp: Temp
    let humidity: Int
    let weather: [Weather]
    let pop: Double
    
    var dayOfWeek: String {
        dateTime.toDay()
    }
    
    var temperature: String {
        temp.all
    }
    
    var icon: UIImage? {
        guard let weatherDescription = weather.first?.weatherDescription else { return nil }
        return weatherDescription.icon(isDayTime: true)
    }
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity, weather, pop
        case dateTime = "dt"
    }
}

struct Temp: Codable {
    let min: Double
    let max: Double
    let night: Double
    
    var all: String {
        let minTemperature = min.toTemperature()
        let maxTemperature = max.toTemperature()
        return "\(maxTemperature) / \(minTemperature)"
    }
}
