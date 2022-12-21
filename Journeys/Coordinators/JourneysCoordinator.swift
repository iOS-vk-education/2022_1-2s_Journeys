//
//  JourneysCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 09.11.2022.
//

import Foundation
import UIKit


final class JourneysCoordinator: CoordinatorProtocol {

    // MARK: Private Properties

    private let rootTabBarController: UITabBarController
    private var navigationController = UINavigationController()
    private let tabBarItemFactory: TabBarItemFactoryProtocol
    
    // MARK: Lifecycle

    init(rootTabBarController: UITabBarController) {
        self.rootTabBarController = rootTabBarController
        tabBarItemFactory = TabBarItemFactory()
    }

    // MARK: Public Methods

    func start() {
        let builder = TripInfoModuleBuilder()
        let tripsViewController = builder.build(output: self, firstPageMode: .info, routeId: "")

        navigationController.setViewControllers([tripsViewController], animated: false)

        navigationController.tabBarItem = tabBarItemFactory.getTabBarItem(from: TabBarPage.journeys)

        var controllers = rootTabBarController.viewControllers
        if controllers == nil {
            controllers = [navigationController]
        } else {
            controllers?.append(navigationController)
        }
        rootTabBarController.setViewControllers(controllers, animated: true)
    }

    // TODO: finish
    func finish() {
    }
}

// MARK: TripsModuleOutput

extension JourneysCoordinator: TripsModuleOutput {

}

extension JourneysCoordinator: TripInfoModuleOutput {
    func tripInfoModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
}
