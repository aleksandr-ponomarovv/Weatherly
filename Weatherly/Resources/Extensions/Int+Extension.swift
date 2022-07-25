//
//  Int+Extension.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import Foundation

extension Int {
    func toHours() -> String {
        return Date(timeIntervalSince1970: Double(self)).toHours()
    }
    
    func toDay() -> String {
        return Date(timeIntervalSince1970: Double(self)).toDay()
    }
    
    func toPercentHumidity() -> String {
        return String(self) + "%"
    }
    
    func toCalendarDate() -> String {
        return Date(timeIntervalSince1970: Double(self)).toCalendarDate()
    }
}
