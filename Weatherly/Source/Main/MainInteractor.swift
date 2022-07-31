//   
//  MainInteractor.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import CoreLocation
import Realm
import RealmSwift

protocol MainInteractorType {
    var selectedLocation: Location? { get }
    var current: CurrentModel? { get }
    var hourCellModels: [HourCellModel] { get }
    var dayCellModels: [DayCellModel] { get }
    
    func updateWeatherData(completion: @escaping(Responce<Bool>) -> Void)
    func save(location: Location)
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Location>>) -> Void)
}

class MainInteractor: MainInteractorType {
    
    private let weatherService = WeatherService()
    private let realmManager = RealmManager.shared
    private var hourlyEntity: HourlyEntity?
    private var notificationToken: NotificationToken?
    
    // MARK: - Protocol property
    var selectedLocation: Location? {
        return realmManager.getObject(primaryKey: RealmKeyConstants.locationId)
    }
    
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
    
    // MARK: - Protocol methods
    func updateWeatherData(completion: @escaping(Responce<Bool>) -> Void) {
        guard let latitude = selectedLocation?.latitude,
              let longitude = selectedLocation?.longitude else { return }
        
        weatherService.getHourly(lat: String(latitude), lon: String(longitude)) { [weak self] result in
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
    
    func save(location: Location) {
        realmManager.addOrUpdate(object: location)
    }
    
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Location>>) -> Void) {
        notificationToken = realmManager.observeUpdateChanges(type: Location.self, completion)
    }
}
