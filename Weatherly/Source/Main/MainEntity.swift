//   
//  MainEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import Foundation

protocol MainEntityProtocol {
    var city: String? { get }
    var weatherDescription: String? { get }
    var currentTemperature: String { get }
    
    func getMinMaxTemperature() -> String?
}

struct MainEntity: MainEntityProtocol, Codable {
    let city: String?
    let weatherDescription: String?
    let currentTemperature: String
    
    private let todayTemp: Temp?
    
    init(city: String?, weatherDescription: String?, currentTemperature: String, todayTemp: Temp?) {
        self.city = city
        self.weatherDescription = weatherDescription
        self.currentTemperature = currentTemperature
        self.todayTemp = todayTemp
    }
    
    func getMinMaxTemperature() -> String? {
        guard let temperature = todayTemp else { return nil }
        
        let max = Localizable.max.key.localized().capitalized
        let min = Localizable.min.key.localized()
        let maxTemperature = temperature.max.toTemperature()
        let minTemperature = temperature.min.toTemperature()
        return "\(max). \(maxTemperature), \(min). \(minTemperature)"
    }
}
