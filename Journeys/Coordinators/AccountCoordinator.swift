//
//  AccountCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.12.2022.
//

import Foundation
import UIKit

final class AccountCoordinator: CoordinatorProtocol {

    // MARK: Private Properties

    private let rootTabBarController: UITabBarController
    private var navigationController: UINavigationController
    private let tabBarItemFactory: TabBarItemFactoryProtocol
    
    // MARK: Lifecycle

    init(rootTabBarController: UITabBarController) {
        self.rootTabBarController = rootTabBarController
        navigationController = UINavigationController()
        tabBarItemFactory = TabBarItemFactory()
    }

    // MARK: Public Methods

    // TODO: start
    func start() {
        let builder = AccountModuleBuilder()
        let accountViewController = builder.build(output: self)

        navigationController.setViewControllers([accountViewController], animated: false)

        navigationController.tabBarItem = tabBarItemFactory.getTabBarItem(from: TabBarPage.account)

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

extension AccountCoordinator: AccountModuleOutput {

}
