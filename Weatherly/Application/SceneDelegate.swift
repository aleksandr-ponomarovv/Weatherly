//   
//  SceneDelegate.swift
//  Weatherly
//
//  Created by Aleksandr on 21.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var appCoordinator: BaseCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        appCoordinator = AppCoordinator()
        appCoordinator?.start()
    }
}
