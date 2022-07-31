//   
//  SearchLocationRouter.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

protocol SearchLocationRouterType {
    func popViewController()
}

class SearchLocationRouter: SearchLocationRouterType {
    
    private weak var viewController: SearchLocationViewController?
    
    init(viewController: SearchLocationViewController) {
        self.viewController = viewController
    }
    
    func popViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
