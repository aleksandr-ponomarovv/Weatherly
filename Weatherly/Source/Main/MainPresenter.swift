//   
//  MainPresenter.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import UIKit

protocol MainPresenterType {
    var city: String? { get }
    var weatherDescription: String? { get }
    var currentTemperature: String { get }
    var minMaxTemperature: String? { get }
    var numberOfSections: Int { get }
    
    var hourCellModels: [HourCellModel] { get }
    var informationCellTitle: String? { get }
    
    func viewDidLoad()
    func didTapNavigationLeftButton()
    func didTapNavigationRightButton()
    func weatherSection(by index: Int) -> WeatherSection
    func numberOfRowsInSection(section: Int) -> Int
    func dayCellModel(at indexPath: IndexPath) -> DayCellModel
    func descriptionCellModel(at indexPath: IndexPath) -> DescriptionCellModel
    func tableView(heightForRowAt indexPath: IndexPath) -> CGFloat
    func didUpdateLocations(location: Location)
}

class MainPresenter: MainPresenterType {
    
    private let interactor: MainInteractorType
    private let router: MainRouterType
    private weak var view: MainViewType?
    
    // MARK: - Protocol property
    let numberOfSections: Int = WeatherSection.allCases.count
    
    var city: String? {
        interactor.selectedLocation?.name
    }
    
    var weatherDescription: String? {
        interactor.current?.weather.first?.weatherDescription?.rawValue
    }
    
    var currentTemperature: String {
        guard let current = interactor.current else { return Localizable.temperature.key.localized() }
        
        return current.temp.toIntegerString()
    }
    
    var minMaxTemperature: String? {
        guard let temperature = interactor.days.first?.temp else { return nil }
        
        let max = Localizable.max.key.localized().capitalized
        let min = Localizable.min.key.localized()
        let maxTemperature = temperature.max.toTemperature()
        let minTemperature = temperature.min.toTemperature()
        return "\(max). \(maxTemperature), \(min). \(minTemperature)"
    }
    
    var hourCellModels: [HourCellModel] {
        interactor.hours
    }
    
    var informationCellTitle: String? {
        guard let current = interactor.current,
              let weather = current.weather.first,
              let description = weather.weatherDescription?.rawValue,
              let temperature = interactor.days.first?.temp else { return nil }
        
        let firstSentence = "Today: \(description)."
        let secondSentence = "Air temperature \(current.temperature), max temperature \(temperature.max.toTemperature())"
        return "\(firstSentence) \(secondSentence)"
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
        subscribeLocationNotification()
        updateWeatherData()
    }
    
    func didTapNavigationLeftButton() {
        router.showSearchScreen()
    }
    
    func didTapNavigationRightButton() {
        router.showMapScreen()
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
            return interactor.days.count
        case .information:
            return 1
        case .description:
            return interactor.descriptions.count
        }
    }
    
    func dayCellModel(at indexPath: IndexPath) -> DayCellModel {
        return interactor.days[indexPath.row]
    }
    
    func descriptionCellModel(at indexPath: IndexPath) -> DescriptionCellModel {
        return interactor.descriptions[indexPath.row]
    }
    
    func tableView(heightForRowAt indexPath: IndexPath) -> CGFloat {
        let weatherSection = weatherSection(by: indexPath.section)
        switch weatherSection {
        case .hours:
            return 140
        case .days:
            return 70
        case .information:
            return 70
        case .description:
            return 70
        }
    }
    
    func didUpdateLocations(location: Location) {
        interactor.save(location: location)
    }
}

// MARK: - Private methods
private extension MainPresenter {
    func subscribeLocationNotification() {
        interactor.subscribeLocationNotification { [weak self] change in
            guard let self = self else { return }
            
            switch change {
            case .initial, .update:
                self.updateWeatherData()
            case .error:
                break
            }
        }
    }
    
    func updateWeatherData() {
        interactor.updateWeatherData() { [weak self] result in
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
