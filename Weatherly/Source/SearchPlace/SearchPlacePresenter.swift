//   
//  ViperPresenter.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import Foundation

protocol SearchPlacePresenterType {
    var numberOfItemsInSection: Int { get }
    
    func getTitle(at indexPath: IndexPath) -> String?
    func getCity(at indexPath: IndexPath) -> City
    func filterCities(text: String)
    func popScreen()
}

class SearchPlacePresenter: SearchPlacePresenterType {
    
    private let interactor: SearchPlaceInteractorType
    private let router: SearchPlaceRouterType
    private weak var view: SearchPlaceViewType?
    
    // MARK: - Protocol property
    var numberOfItemsInSection: Int {
        interactor.filteredCities.count
    }
    
    init(interactor: SearchPlaceInteractorType,
         router: SearchPlaceRouterType,
         view: SearchPlaceViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Protocol methods
    func getTitle(at indexPath: IndexPath) -> String? {
        return interactor.filteredCities[indexPath.row].name
    }
    
    func getCity(at indexPath: IndexPath) -> City {
        return interactor.filteredCities[indexPath.row]
    }
    
    func filterCities(text: String) {
        interactor.filterCities(text: text)
        view?.reloadTableView()
    }
    
    func popScreen() {
        router.popViewController()
    }
}
