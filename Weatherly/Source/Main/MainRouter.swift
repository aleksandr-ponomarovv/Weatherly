//   
//  MainRouter.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import Foundation

protocol MainRouterType {
    func showSearchScreen()
    func showMapScreen()
}

class MainRouter: MainRouterType {
    
    private weak var viewController: MainViewController?
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func showSearchScreen() {
        let searchPlaceViewController = SearchLocationViewController()
        let configurator: SearchLocationConfiguratorType = SearchLocationConfigurator()
        configurator.configure(viewController: searchPlaceViewController)
        viewController?.navigationController?.pushViewController(searchPlaceViewController, animated: true)
    }
    
    func showMapScreen() {
        let mapViewController = MapViewController()
        let configurator: MapConfiguratorType = MapConfigurator()
        configurator.configure(viewController: mapViewController)
        viewController?.navigationController?.pushViewController(mapViewController, animated: true)
    }
}
