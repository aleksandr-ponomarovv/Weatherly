//
//  Double+Extension.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import Foundation

extension Double {
    func toTemperature() -> String {
        return String(format: "%.f", self) + "°"
    }
    
    func toSpeed() -> String {
        let speed = String(format: "%.f", self)
        let ending = Localizable.metersPerSecond.key.localized()
        return "\(speed) \(ending)"
    }
    
    func toVisibility() -> String {
        let distance = String(format: "%.f", self / 1000)
        let ending = Localizable.km.key.localized()
        return "\(distance) \(ending)"
    }
}
