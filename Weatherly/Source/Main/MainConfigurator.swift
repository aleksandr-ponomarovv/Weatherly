//   
//  MainConfigurator.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import Foundation

protocol MainConfiguratorType {
    func configure(viewController: MainViewController)
}

class MainConfigurator: MainConfiguratorType {
    
    func configure(viewController: MainViewController) {
        let interactor = MainInteractor()
        let router = MainRouter(viewController: viewController)
        let presenter = MainPresenter(interactor: interactor, router: router, view: viewController)
        viewController.presenter = presenter
    }
}
