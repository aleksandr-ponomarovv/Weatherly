//   
//  ViperViewController.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import UIKit

protocol SearchPlaceDelegate: AnyObject {
    func searchPlaceDidSelect(_ searchPlaceViewController: SearchPlaceViewController, city: City)
}

protocol SearchPlaceViewType: AnyObject {
    func reloadTableView()
}

class SearchPlaceViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: SearchPlacePresenterType?
    weak var delegate: SearchPlaceDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        subscribeNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - SearchPlaceViewType
extension SearchPlaceViewController: SearchPlaceViewType {
    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchPlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItemsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cell: TextCell.self, for: indexPath)
        cell.title = presenter?.getTitle(at: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchPlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        
        let city = presenter.getCity(at: indexPath)
        delegate?.searchPlaceDidSelect(self, city: city)
        presenter.popScreen()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UISearchBarDelegate
extension SearchPlaceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.filterCities(text: searchText)
    }
}

// MARK: - Private methods
private extension SearchPlaceViewController {
    func configureUI() {
        localizeUI()
        searchBar.delegate = self
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(cell: TextCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(localizeUI), name: .languageChange, object: nil)
    }
    
    @objc func localizeUI() {
        
    }
}
