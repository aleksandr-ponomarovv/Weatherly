//
//  WeatherService.swift
//  Weatherly
//
//  Created by Aleksandr on 23.07.2022.
//

import Alamofire

final class WeatherService: APIManagerProtocol {
    
    func getHourly(lat: String, lon: String, completion: @escaping(Responce<HourlyEntity>) -> Void) {
        let api: WeatherApi = .getHourly(lat: lat, lon: lon)
        AF.request(api).responseDecodable(of: HourlyEntity.self) { response in
            print("RESPONSE ENTITY: \(response.data?.json ?? "")")
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(self.errorHandling(error: error)))
            }
        }
    }
}
