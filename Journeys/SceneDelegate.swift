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

//        print(FirebaseService().obtainRoute2(with: "ptlOYsXo6TFTuvemhSpH"))
        let navigationController = UINavigationController()
        let firebaseService = FirebaseService()
        coordinator = AppCoordinator(navigationController: navigationController, firebaseService: firebaseService)

        coordinator?.start()

        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

    }
}
