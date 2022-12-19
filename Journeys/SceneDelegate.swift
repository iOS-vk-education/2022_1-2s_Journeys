//
//  SceneDelegate.swift
//  Journeys
//
//  Created by Сергей Адольевич on 02.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: CoordinatorProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let initialViewController = StuffModuleBuilder().build()
        let navigationViewController = UINavigationController(rootViewController: initialViewController)
        navigationViewController.view.backgroundColor = .systemBackground
        
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
//        let tabBarController = UITabBarController()
//        tabBarController.setViewControllers([], animated: false)
//        window?.rootViewController = tabBarController
//        window?.makeKeyAndVisible()
//
//        coordinator = AppCoordinator(tabBarController: tabBarController)
//
//        coordinator?.start()
    }

}
