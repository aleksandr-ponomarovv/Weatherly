//
//  JsonReader.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

final class JsonReader {
    
    enum FileNames: String {
        case uaCities = "ua-cities"
    }
    
    func readLocalFile<T: Codable>(for name: FileNames) -> T? {
        guard let bundlePath = Bundle.main.path(forResource: name.rawValue, ofType: "json"),
              let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8),
              let decodedData = try? JSONDecoder().decode(T.self, from: jsonData) else { return nil }
        return decodedData
    }
}
