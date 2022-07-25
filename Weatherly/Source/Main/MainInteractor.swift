//   
//  MainInteractor.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import CoreLocation

protocol MainInteractorType {
    var locationName: String? { get }
    var current: CurrentModel? { get }
    var hourCellModels: [HourCellModel] { get }
    var dayCellModels: [DayCellModel] { get }
    var lat: String? { get }
    var lon: String? { get }
    
    func updateHourlyEntity(lat: String, lon: String, completion: @escaping(Responce<Bool>) -> Void)
    func checkLocationPermission(completion: @escaping(Bool) -> Void)
}

class MainInteractor: MainInteractorType {
        
    private let weatherService = WeatherService()
    private let locationManager = LocationManager.shared
    private var hourlyEntity: HourlyEntity?
    
    // MARK: - Protocol property
    var locationName: String?
    
    var current: CurrentModel? {
        hourlyEntity?.current
    }
    
    var hourCellModels: [HourCellModel] {
        guard let hours = hourlyEntity?.hourly else { return [] }
        
        let hoursInDay = 24
        return hours.count >= hoursInDay ? Array(hours[0..<hoursInDay]) : hours
    }
    
    var dayCellModels: [DayCellModel] {
        return hourlyEntity?.daily ?? []
    }
    
    var lat: String? {
        locationManager.latitude
    }
    
    var lon: String? {
        locationManager.longitude
    }
    
    init(locationManagerDelegate: LocationManagerDelegate) {
        locationManager.delegate = locationManagerDelegate
    }
    
    // MARK: - Protocol methods
    func updateHourlyEntity(lat: String, lon: String, completion: @escaping(Responce<Bool>) -> Void) {
        getPlaceName(lat: lat, lon: lon)
        weatherService.getHourly(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let hourlyEntity):
                self.hourlyEntity = hourlyEntity
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkLocationPermission(completion: @escaping (Bool) -> Void) {
        locationManager.checkPermission(authorizedHandler: completion)
    }
}

// MARK: - Private methods
private extension MainInteractor {
    func getPlaceName(lat: String, lon: String) {
        guard let lat = lat.toDouble(), let lon = lon.toDouble() else { return }
        
        locationManager.getPlaceName(lat: lat, lon: lon) { [weak self] name in
            guard let self = self,
                  let name = name else { return }
            
            self.locationName = name
        }
    }
}
