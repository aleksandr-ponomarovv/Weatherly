//   
//  MainViewController.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import UIKit
import CoreLocation

protocol MainViewType: AnyObject {
    func updateUI()
}

class MainViewController: UIViewController {
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var forecastView: UIView!
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: MainPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        configureUI()
        subscribeNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - MainViewType
extension MainViewController: MainViewType {
    func updateUI() {
        title = presenter?.title
        timeLabel.text = presenter?.time
        weatherImageView.image = presenter?.weatherIcon
        temperatureLabel.text = presenter?.temperature
        humidityLabel.text = presenter?.humidity
        windSpeedLabel.text = presenter?.windSpeed
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else { return .init() }
        
        let weatherSection = presenter.weatherSection(by: indexPath.section)
        switch weatherSection {
        case .hours:
            let cell = tableView.dequeueReusable(cell: HoursCell.self, for: indexPath)
            cell.models = presenter.hourCellModels
            return cell
        case .days:
            let cell = tableView.dequeueReusable(cell: DayCell.self, for: indexPath)
            cell.model = presenter.getDayCellModel(at: indexPath)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.tableView(heightForRowAt: indexPath) ?? 0
    }
}

// MARK: - LocationManagerDelegate
extension MainViewController: LocationManagerDelegate {
    func locationManagerDidUpdateLocations(lat: String, lon: String) {
        presenter?.didUpdateLocations(lat: lat, lon: lon)
    }
}

// MARK: - SearchPlaceDelegate
extension MainViewController: SearchPlaceDelegate {
    func searchPlaceDidSelect(_ searchPlaceViewController: SearchPlaceViewController, city: City) {
        presenter?.didSelect(city: city)
    }
}

// MARK: - Private methods
private extension MainViewController {
    func configureUI() {
        localizeUI()
        setupNavigationBar()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cell: HoursCell.self)
        tableView.register(cell: DayCell.self)
    }
    
    func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(localizeUI), name: .languageChange, object: nil)
    }
    
    @objc func localizeUI() {
        
    }
}

// MARK: - Private navigation methods
private extension MainViewController {
    func setupNavigationBar() {
        guard let rightButtonImage = R.image.ic_my_location(),
              let leftButtonImage = R.image.ic_place() else { return }
        
        setupNavigationLeftButton(image: leftButtonImage, action: #selector(navigationLeftButtonAction))
        setupNavigationRightButton(image: rightButtonImage, action: #selector(navigationRightButtonAction))
    }
    
    @objc func navigationLeftButtonAction() {
        presenter?.didTapNavigationLeftButton()
    }
    
    @objc func navigationRightButtonAction() {
        presenter?.didTapNavigationRightButton()
    }
}
