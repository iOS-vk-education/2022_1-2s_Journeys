//
//  EventsCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.12.2022.
//

import Foundation
import UIKit

final class EventsCoordinator: CoordinatorProtocol {
    
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
        let eventsViewController = EventsViewController()
        eventsViewController.moduleOutput = self
        navigationController.setViewControllers([eventsViewController], animated: false)
        
        navigationController.tabBarItem = tabBarItemFactory.getTabBarItem(from: TabBarPage.events)
        
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
    
    func openTapToAddButtonViewController() {
        let eventsViewController = TapToAddButtonViewController()
        eventsViewController.moduleOutput = self
        navigationController.pushViewController(eventsViewController, animated: true)
    }
    
    func openSuggestionViewController() {
        let eventsViewController = SuggestionViewController()
        eventsViewController.moduleOutput = self
        navigationController.pushViewController(eventsViewController, animated: true)
    }
    
    func openAddingEventViewController() {
        let eventsViewController = AddingEventViewController()
        eventsViewController.moduleOutput = self
        navigationController.pushViewController(eventsViewController, animated: true)
    }
    
    func openEventViewController() {
        let eventsViewController = EventsViewController()
        eventsViewController.moduleOutput = self
        navigationController.pushViewController(eventsViewController, animated: true)
    }
}
