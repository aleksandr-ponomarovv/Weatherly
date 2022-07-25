//   
//  MainPresenter.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import UIKit

protocol MainPresenterType {
    var title: String? { get }
    var numberOfSections: Int { get }
    var time: String? { get }
    var weatherIcon: UIImage? { get }
    var temperature: String? { get }
    var humidity: String? { get }
    var windSpeed: String? { get }
    var hourCellModels: [HourCellModel] { get }
    
    func viewDidLoad()
    func didTapNavigationLeftButton()
    func didTapNavigationRightButton()
    func weatherSection(by index: Int) -> WeatherSection
    func numberOfRowsInSection(section: Int) -> Int
    func getDayCellModel(at indexPath: IndexPath) -> DayCellModel
    func tableView(heightForRowAt indexPath: IndexPath) -> CGFloat
    func didUpdateLocations(lat: String, lon: String)
    func didSelect(city: City)
}

class MainPresenter: MainPresenterType {
    
    private let interactor: MainInteractorType
    private let router: MainRouterType
    private weak var view: MainViewType?
    
    // MARK: - Protocol property
    let numberOfSections: Int = 2
    
    var title: String? {
        return interactor.locationName
    }
    
    var time: String? {
        interactor.current?.time
    }
    
    var weatherIcon: UIImage? {
        interactor.current?.icon
    }
    
    var temperature: String? {
        interactor.current?.temperature
    }
    
    var humidity: String? {
        interactor.current?.percentHumidity
    }
    
    var windSpeed: String? {
        interactor.current?.windSpeedMetersPerSecond
    }
    
    var hourCellModels: [HourCellModel] {
        interactor.hourCellModels
    }
    
    init(interactor: MainInteractorType,
         router: MainRouterType,
         view: MainViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Protocol methods
    func viewDidLoad() {
        updateHourlyEntityByLastLocation()
    }
    
    func didTapNavigationLeftButton() {
        router.pushSearchScreen()
    }
    
    func didTapNavigationRightButton() {
        interactor.checkLocationPermission { [weak self] hasPermission in
            guard let self = self else { return }
            
            if hasPermission {
                self.updateHourlyEntityByLastLocation()
            } else {
                self.router.presentSettingsScreen()
            }
        }
    }
    
    func weatherSection(by index: Int) -> WeatherSection {
        return WeatherSection.allCases[index]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        let weatherSection = weatherSection(by: section)
        switch weatherSection {
        case .hours:
            return 1
        case .days:
            return interactor.dayCellModels.count
        }
    }
    
    func getDayCellModel(at indexPath: IndexPath) -> DayCellModel {
        return interactor.dayCellModels[indexPath.row]
    }
    
    func tableView(heightForRowAt indexPath: IndexPath) -> CGFloat {
        let weatherSection = weatherSection(by: indexPath.section)
        switch weatherSection {
        case .hours:
            return 140
        case .days:
            return 70
        }
    }
    
    func didUpdateLocations(lat: String, lon: String) {
        updateHourlyEntity(lat: lat, lon: lon)
    }
    
    func didSelect(city: City) {
        updateHourlyEntity(lat: city.lat, lon: city.log)
    }
}

// MARK: - Private methods
private extension MainPresenter {
    func updateHourlyEntityByLastLocation() {
        guard let lat = interactor.lat,
              let lon = interactor.lon else { return }
        
        updateHourlyEntity(lat: lat, lon: lon)
    }
    
    func updateHourlyEntity(lat: String, lon: String) {
        interactor.updateHourlyEntity(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.view?.updateUI()
            case .failure:
                break
            }
        }
    }
}
