//
//  DescriptionCellEntity.swift
//  Weatherly
//
//  Created by Aleksandr on 07.08.2022.
//

import Foundation

enum DescriptionSection: String, CaseIterable {
    case sunrise = "SUNRISE"
    case sunset = "SUNSET"
    case humidity = "HUMIDITY"
    case wind = "WIND"
    case feelsLike = "FEELS LIKE"
    case ressure = "RESSURE"
    case visibility = "VISIBILITY"
    case uvIndex = "UV INDEX"
}

class DescriptionCellEntity: DescriptionCellModel {
    let title: String
    let value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
