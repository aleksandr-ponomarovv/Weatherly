//   
//  MapConfigurator.swift
//  Weatherly
//
//  Created by Aleksandr on 30.07.2022.
//

import Foundation

protocol MapConfiguratorType {
    func configure(viewController: MapViewController)
}

class MapConfigurator: MapConfiguratorType {
    
    func configure(viewController: MapViewController) {
        let interactor = MapInteractor(locationManagerDelegate: viewController)
        let router = MapRouter(viewController: viewController)
        let presenter = MapPresenter(interactor: interactor, router: router, view: viewController)
        viewController.presenter = presenter
    }
}
