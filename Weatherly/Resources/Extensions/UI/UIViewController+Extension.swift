//
//  UIViewController+Extension.swift
//  Weatherly
//
//  Created by Aleksandr on 24.07.2022.
//

import UIKit

// MARK: - NavigationBar
extension UIViewController {
    func setupNavigationLeftButton(image: UIImage, action: Selector) {
        let leftBarButtonItem = UIBarButtonItem(image: image,
                                                style: .done,
                                                target: self,
                                                action: action)
        leftBarButtonItem.tintColor = R.color.navigation_button()
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setupNavigationRightButton(image: UIImage, action: Selector) {
        let rightBarButtonItem = UIBarButtonItem(image: image,
                                                 style: .done,
                                                 target: self,
                                                 action: action)
        rightBarButtonItem.tintColor = R.color.navigation_button()
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

// MARK: - Routing
extension UIViewController {
    func presentSettingsScreen(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsActionTitle = Localizable.alertSettings.key.localized()
        let okActionTitle = Localizable.alertOk.key.localized()
        let settingsAction = UIAlertAction(title: settingsActionTitle, style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsUrl) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        let okAction = UIAlertAction(title: okActionTitle, style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
