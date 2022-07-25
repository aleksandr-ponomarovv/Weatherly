//   
//  ViperConfigurator.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

protocol SearchPlaceConfiguratorType {
    func configure(viewController: SearchPlaceViewController)
}

class SearchPlaceConfigurator: SearchPlaceConfiguratorType {
    
    func configure(viewController: SearchPlaceViewController) {
        let interactor = SearchPlaceInteractor()
        let router = SearchPlaceRouter(viewController: viewController)
        let presenter = SearchPlacePresenter(interactor: interactor, router: router, view: viewController)
        viewController.presenter = presenter
    }
}
