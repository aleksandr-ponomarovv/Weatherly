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
    var current: Current? { get }
    var hours: [Hourly] { get }
    var days: [Daily] { get }
    var descriptions: [DescriptionCellEntity] { get }
    
    func updateWeatherData(completion: @escaping(Responce<Bool>) -> Void)
    func save(location: Location)
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Location>>) -> Void)
}

class MainInteractor: MainInteractorType {
    
    private let weatherService = WeatherService()
    private let realmManager = RealmManager.shared
    private var notificationToken: NotificationToken?
    
    // MARK: - Protocol property
    var selectedLocation: Location? {
        realmManager.getObject(primaryKey: RealmKeyConstants.locationId)
    }
    
    var current: Current? {
        hourlyEntity?.current
    }
    
    var hours: [Hourly] {
        guard let hoursList = hourlyEntity?.hourly else { return [] }
        
        let hours = Array(hoursList)
        let hoursInDay = 24
        return hours.count >= hoursInDay ? Array(hours[0..<hoursInDay]) : hours
    }
    
    var days: [Daily] {
        guard let daysList = hourlyEntity?.daily else { return [] }
        
        return Array(daysList)
    }
    
    var descriptions: [DescriptionCellEntity] {
        getDescriptions()
    }
    
    private var hourlyEntity: HourlyEntity? {
        return realmManager.getObject(primaryKey: RealmKeyConstants.hourlyEntityId)
    }
    
    // MARK: - Protocol methods
    func updateWeatherData(completion: @escaping(Responce<Bool>) -> Void) {
        guard let latitude = selectedLocation?.latitude,
              let longitude = selectedLocation?.longitude else { return }
        
        weatherService.getHourly(lat: String(latitude), lon: String(longitude)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let hourlyEntity):
                self.realmManager.addOrUpdate(object: hourlyEntity)
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

// MARK: - Private methods
private extension MainInteractor {
    func getDescriptions() -> [DescriptionCellEntity] {
        let descriptions: [DescriptionCellEntity] = DescriptionSection.allCases.compactMap { descriptionSection in
            guard let current = current else { return nil }
            
            let title = descriptionSection.rawValue
            switch descriptionSection {
            case .sunrise:
                return DescriptionCellEntity(title: title, value: current.sunrise.toHoursWithMinutes())
            case .sunset:
                return DescriptionCellEntity(title: title, value: current.sunset.toHoursWithMinutes())
            case .humidity:
                return DescriptionCellEntity(title: title, value: current.humidity.toPercentHumidity())
            case .wind:
                return DescriptionCellEntity(title: title, value: current.windSpeed.toSpeed())
            case .feelsLike:
                return DescriptionCellEntity(title: title, value: current.feelsLike.toTemperature())
            case .ressure:
                return DescriptionCellEntity(title: title, value: current.pressure.toPressure())
            case .visibility:
                return DescriptionCellEntity(title: title, value: current.visibility.toVisibility())
            case .uvIndex:
                return DescriptionCellEntity(title: title, value: String(current.uvi))
            }
        }
        return descriptions
    }
}
