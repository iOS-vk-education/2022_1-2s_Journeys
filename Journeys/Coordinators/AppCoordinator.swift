//
//  AppCoordinator.swift
//  Journeys
//
//  Created by Ищенко Анастасия on 07.11.2022.
//
import Foundation
import UIKit

class AppCoordinator: NSObject, AppCoordinatorProtocol {

    var childCoordinators = [CoordinatorProtocol]()
    let tabBarController: UITabBarController
    weak var journeysCoordinatorInput: CoordinatorProtocol?
    weak var eventsCoordinatorInput: CoordinatorProtocol?
    weak var settingsCoordinatorInput: CoordinatorProtocol?
    
    private var firebaseService: FirebaseServiceProtocol

    init(tabBarController: UITabBarController, firebaseService: FirebaseServiceProtocol) {
        self.tabBarController = tabBarController
        self.firebaseService = firebaseService
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }

    func start() {
        tabBarController.delegate = self
        
        // TODO: Add color
        tabBarController.tabBar.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor)
        TabBarPage.allCases.forEach {
            getTabController($0)
        }
    }

    // TODO: finish
    func finish() {

    }
    
    func reload() {
        tabBarController.viewControllers = nil
        childCoordinators.forEach { coordinator in
            coordinator.start()
            if let settingsCoordinator = coordinator as? SettingsCoordinator {
                settingsCoordinator.settingsModuleWantsToOpenSettingsSubModule(type: .language, animated: false)
            }
        }

        tabBarController.selectedIndex = 2
    }
    
    // MARK: Private

    private func getTabController(_ page: TabBarPage) {
        switch page {
        case .journeys:
            let journeysCoordinator = JourneysCoordinator(rootTabBarController: tabBarController,
                                                          firebaseService: firebaseService)
            journeysCoordinator.start()
            childCoordinators.append(journeysCoordinator)
            journeysCoordinatorInput = journeysCoordinator

        case .events:
            let eventsCoordinator = EventsCoordinator(rootTabBarController: tabBarController)
            eventsCoordinator.start()
            childCoordinators.append(eventsCoordinator)
            eventsCoordinatorInput = eventsCoordinator

        case .settings:
            let settingsCoordinator = SettingsCoordinator(rootTabBarController: tabBarController,
                                                        firebaseService: firebaseService)
            settingsCoordinator.start()
            childCoordinators.append(settingsCoordinator)
            settingsCoordinatorInput = settingsCoordinator
        }
    }
}

// MARK: UITabBarControllerDelegate

extension AppCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // TODO: Implement didSelect method
    }
}
