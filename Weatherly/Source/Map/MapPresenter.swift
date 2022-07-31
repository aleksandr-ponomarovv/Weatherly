//   
//  MapPresenter.swift
//  Weatherly
//
//  Created by Aleksandr on 30.07.2022.
//

import Foundation

protocol MapPresenterType {
    func viewDidLoad()
    func viewDidAppear()
    func didTapNavigationRightButton()
    func didTapOnMap(latitude: Double, longitude: Double)
    func didUpdateLocations(location: Location)
}

class MapPresenter: MapPresenterType {
    
    private let interactor: MapInteractorType
    private let router: MapRouterType
    private weak var view: MapViewType?
    
    // MARK: - Protocol property
    
    init(interactor: MapInteractorType,
         router: MapRouterType,
         view: MapViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
  
    // MARK: - Protocol methods
    func viewDidLoad() {
        subscribeLocationNotification()
    }
    
    func viewDidAppear() {
        guard let selectedLocation = interactor.selectedLocation else { return }
        
        view?.setupPin(coordinate: selectedLocation.coordinate, title: selectedLocation.name)
    }
    
    func didTapNavigationRightButton() {
        interactor.checkLocationPermission { [weak self] hasPermission in
            guard let self = self else { return }
            
            if hasPermission {
                self.interactor.startUpdatingLocation()
            } else {
                self.router.showSettingsScreen()
            }
        }
    }
    
    func didTapOnMap(latitude: Double, longitude: Double) {
        interactor.saveLocation(latitude: latitude, longitude: longitude)
    }
    
    func didUpdateLocations(location: Location) {
        interactor.save(location: location)
    }
}

// MARK: - Private methods
private extension MapPresenter {
    func subscribeLocationNotification() {
        interactor.subscribeLocationNotification { [weak self] change in
            guard let self = self else { return }
            
            switch change {
            case .initial(let locations):
                guard let location = locations.last else { return }
                
                self.view?.setupPin(coordinate: location.coordinate, title: location.name)
            case .update(let locations, _, _, _):
                guard let location = locations.last else { return }
                
                self.view?.setupPin(coordinate: location.coordinate, title: location.name)
            case .error:
                break
            }
        }
    }
}
