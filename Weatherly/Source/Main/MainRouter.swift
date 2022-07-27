//   
//  MainRouter.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import Foundation

protocol MainRouterType {
    func showSettingsScreen()
    func showSearchScreen()
}

class MainRouter: MainRouterType {
    
    private weak var viewController: MainViewController?
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func showSettingsScreen() {
        viewController?.presentSettingsScreen(title: Localizable.locationPermissionTitle.key.localized(),
                                              message: Localizable.locationPermissionMessage.key.localized())
    }
    
    func showSearchScreen() {
        let searchPlaceViewController = SearchPlaceViewController()
        searchPlaceViewController.delegate = viewController
        let configurator: SearchPlaceConfiguratorType = SearchPlaceConfigurator()
        configurator.configure(viewController: searchPlaceViewController)
        viewController?.navigationController?.pushViewController(searchPlaceViewController, animated: true)
    }
}
