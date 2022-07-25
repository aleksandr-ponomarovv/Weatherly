//   
//  AppCoordinator.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import UIKit

protocol BaseCoordinator {
    func start()
}

class AppCoordinator: BaseCoordinator {
    
    private lazy var window: UIWindow? = {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        return window
    }()
    
    func start() {
        window?.rootViewController = startController()
        window?.makeKeyAndVisible()
    }
}

// MARK: - Private methods
private extension AppCoordinator {
    func startController() -> UIViewController {
        let viewController = MainViewController()
        let configurator: MainConfiguratorType = MainConfigurator()
        configurator.configure(viewController: viewController)
        return WeatherlyNavigationController(rootViewController: viewController)
    }
}
