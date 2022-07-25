//
//  Date+Extension.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import Foundation

extension Date {
    func toHours() -> String {
        return date(format: "HH")
    }
    
    func toDay() -> String {
        return date(format: "EE")
    }
    
    func toCalendarDate() -> String {
        return date(format: "EE, dd MMMM")
    }
    
    func date(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
