//   
//  MapRouter.swift
//  Weatherly
//
//  Created by Aleksandr on 30.07.2022.
//

import Foundation

protocol MapRouterType {
    func showSettingsScreen()
}

class MapRouter: MapRouterType {
    
    private weak var viewController: MapViewController?
    
    init(viewController: MapViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Protocol methods
    func showSettingsScreen() {
        viewController?.presentSettingsScreen(title: Localizable.locationPermissionTitle.key.localized(),
                                              message: Localizable.locationPermissionMessage.key.localized())
    }
}
