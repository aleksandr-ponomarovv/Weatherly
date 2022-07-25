//   
//  ViperRouter.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

protocol SearchPlaceRouterType {
    func popViewController()
}

class SearchPlaceRouter: SearchPlaceRouterType {
    
    private weak var viewController: SearchPlaceViewController?
    
    init(viewController: SearchPlaceViewController) {
        self.viewController = viewController
    }
    
    func popViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
