//   
//  WeatherlyNavigationController.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import UIKit

class WeatherlyNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backItem.tintColor = R.color.navigation_button()
        viewController.navigationItem.backBarButtonItem = backItem
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - Private methods
private extension WeatherlyNavigationController {
    func configureUI() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = R.color.navigation_bg()
        let titleColor = R.color.text_forecast() ?? .white
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
}
