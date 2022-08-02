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
    var temperature: String { get }
    var humidity: String { get }
    var windSpeed: String { get }
    var hourCellModels: [HourCellModel] { get }
    
    func viewDidLoad()
    func didTapNavigationLeftButton()
    func didTapNavigationRightButton()
    func weatherSection(by index: Int) -> WeatherSection
    func numberOfRowsInSection(section: Int) -> Int
    func getDayCellModel(at indexPath: IndexPath) -> DayCellModel
    func tableView(heightForRowAt indexPath: IndexPath) -> CGFloat
    func didUpdateLocations(location: Location)
}

class MainPresenter: MainPresenterType {
    
    private let interactor: MainInteractorType
    private let router: MainRouterType
    private weak var view: MainViewType?
    
    // MARK: - Protocol property
    let numberOfSections: Int = 2
    
    var title: String? {
        return interactor.selectedLocation?.name
    }
    
    var time: String? {
        interactor.current?.time
    }
    
    var weatherIcon: UIImage? {
        interactor.current?.icon
    }
    
    var temperature: String {
        interactor.current?.temperature ?? "temperature"
    }
    
    var humidity: String {
        interactor.current?.percentHumidity ?? "humidity"
    }
    
    var windSpeed: String {
        interactor.current?.windSpeedMetersPerSecond ?? "wind speed"
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
