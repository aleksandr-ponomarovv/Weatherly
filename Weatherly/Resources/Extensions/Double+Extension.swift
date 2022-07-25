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
        return String(format: "%.f", self) + Localizable.metersPerSecond.key.localized()
    }
}
