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
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet private weak var forecastView: UIView!
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: MainPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        configureUI()
    }
}

// MARK: - MainViewType
extension MainViewController: MainViewType {
    func updateUI() {
        setupUI()
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
            cell.model = presenter.dayCellModel(at: indexPath)
            return cell
        case .information:
            let cell = tableView.dequeueReusable(cell: InformationCell.self, for: indexPath)
            cell.title = presenter.informationCellTitle
            return cell
        case .description:
            let cell = tableView.dequeueReusable(cell: DescriptionCell.self, for: indexPath)
            cell.model = presenter.descriptionCellModel(at: indexPath)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter else { return 0 }
    
        let weatherSection = presenter.weatherSection(by: indexPath.section)
        switch weatherSection {
        case .hours:
            return 140
        case .days:
            return 70
        case .information:
            return 70
        case .description:
            return 70
        }
    }
}

// MARK: - Private methods
private extension MainViewController {
    func configureUI() {
        setupNavigationBar()
        setupTableView()
        setupUI()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cell: HoursCell.self)
        tableView.register(cell: DayCell.self)
        tableView.register(cell: InformationCell.self)
        tableView.register(cell: DescriptionCell.self)
    }
    
    func setupUI() {
        guard let model = presenter?.model else { return }
        
        cityLabel.text = model.city
        weatherDescriptionLabel.text = model.weatherDescription
        currentTemperatureLabel.text = model.currentTemperature
        minMaxTemperatureLabel.text = model.minMaxTemperature
    }

    // MARK: - Navigation
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
