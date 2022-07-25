//
//  Data+Extension.swift
//  Weatherly
//
//  Created by Aleksandr on 23.07.2022.
//

import Foundation

extension Data {
    var json: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)
    }
}
