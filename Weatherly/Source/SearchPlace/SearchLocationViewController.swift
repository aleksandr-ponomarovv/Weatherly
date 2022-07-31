//   
//  ViperViewController.swift
//  Weatherly
//
//  Created by Aleksandr on 25.07.2022.
//

import UIKit

protocol SearchLocationViewType: AnyObject {
    func reloadTableView()
}

class SearchLocationViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var navigationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(navigationTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    var presenter: SearchLocationPresenterType?

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
extension SearchLocationViewController: SearchLocationViewType {
    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SearchLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cell: TextCell.self, for: indexPath)
        cell.title = presenter?.getLocationTitle(at: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectLocation(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.locationCellHeight ?? 0
    }
}

// MARK: - UITextFieldDelegate
extension SearchLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private methods
private extension SearchLocationViewController {
    func configureUI() {
        localizeUI()
        setupNavigationTextField()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cell: TextCell.self)
    }
    
    func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(localizeUI), name: .languageChange, object: nil)
    }
    
    @objc func localizeUI() {
        navigationTextField.placeholder = Localizable.searchPlaceNavigationTextFieldPlaceholder.key.localized()
    }
}

// MARK: - Private navigation methods
private extension SearchLocationViewController {
    func setupNavigationTextField() {
        setupNavigationTitleView(textField: navigationTextField)
    }
    
    @objc func navigationTextFieldEditingChanged() {
        let text = navigationTextField.text 
        presenter?.findLocations(text: text)
    }
}
