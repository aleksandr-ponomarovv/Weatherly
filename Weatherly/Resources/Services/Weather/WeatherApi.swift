//
//  GEOApi.swift
//  Weatherly
//
//  Created by Aleksandr on 23.07.2022.
//

import Alamofire

enum WeatherApi: URLRequestBuilder {
    
    case getFiveDays(cityName: String)
    case getHourly(lat: String, lon: String)
    
    var path: String {
        switch self {
        case .getFiveDays:
            return "forecast"
        case .getHourly:
            return "onecall"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getFiveDays(let cityName):
            return ["q": cityName, "appid": NetworkConstants.key]
        case .getHourly(let lat, let lon):
            return ["lat": lat, "lon": lon, "exclude": "minutely", "units": "metric", "appid": NetworkConstants.key]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getFiveDays, .getHourly:
            return .get
        }
    }
}
