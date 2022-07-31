//   
//  SearchLocationPresenter.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import UIKit

protocol SearchLocationPresenterType {
    var numberOfRowsInSection: Int { get }
    var locationCellHeight: CGFloat { get }
    
    func findLocations(text: String?)
    func getLocationTitle(at indexPath: IndexPath) -> String?
    func didSelectLocation(at indexPath: IndexPath)
}

class SearchLocationPresenter: SearchLocationPresenterType {
    
    private let interactor: SearchLocationInteractorType
    private let router: SearchLocationRouterType
    private weak var view: SearchLocationViewType?
    
    // MARK: - Protocol property
    var numberOfRowsInSection: Int {
        interactor.locations.count
    }
    
    var locationCellHeight: CGFloat {
        50
    }
    
    init(interactor: SearchLocationInteractorType,
         router: SearchLocationRouterType,
         view: SearchLocationViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Protocol methods
    func findLocations(text: String?) {
        guard let text = text else { return }
        
        interactor.findLocations(text: text) { [weak self] in
            guard let self = self else { return }
            
            self.view?.reloadTableView()
        }
    }
    
    func getLocationTitle(at indexPath: IndexPath) -> String? {
        let location = interactor.locations[indexPath.row]
        guard let name = location.name,
              let country = location.country else { return nil }
        
        return "\(name), \(country)"
    }
    
    func didSelectLocation(at indexPath: IndexPath) {
        let location = interactor.locations[indexPath.row]
        interactor.save(location: location)
        router.popViewController()
    }
}
