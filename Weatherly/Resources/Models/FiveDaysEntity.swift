//
//  WeekEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 23.07.2022.
//

import UIKit

// MARK: - List
struct List: Codable {
    let dateTime: Int
    let main: MainWeatherInformation
    let weather: [Weather]
    let visibility: Int
    let pop: Double
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather, visibility, pop
        case dtTxt = "dt_txt"
        case dateTime = "dt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

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
struct Weather: Codable {
    let identifire: Int
    let weatherDescription: Description
    let icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
        case identifire = "id"
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
