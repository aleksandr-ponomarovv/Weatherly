//   
//  SearchLocationConfigurator.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

protocol SearchLocationConfiguratorType {
    func configure(viewController: SearchLocationViewController)
}

class SearchLocationConfigurator: SearchLocationConfiguratorType {
    
    func configure(viewController: SearchLocationViewController) {
        let interactor = SearchLocationInteractor()
        let router = SearchLocationRouter(viewController: viewController)
        let presenter = SearchLocationPresenter(interactor: interactor, router: router, view: viewController)
        viewController.presenter = presenter
    }
}
