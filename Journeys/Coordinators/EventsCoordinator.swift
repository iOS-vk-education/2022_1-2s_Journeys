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
    private let firebaseService: FirebaseServiceProtocol
    
    // MARK: Lifecycle
    
    let lock = NSLock()
    private let loadingViewGroup = DispatchGroup()
    init(rootTabBarController: UITabBarController, firebaseService: FirebaseServiceProtocol) {
        self.rootTabBarController = rootTabBarController
        self.firebaseService = firebaseService
        tabBarItemFactory = TabBarItemFactory()
    }
    // MARK: Public Methods
    func start() {
        let eventsModuleBuilder = EventsModuleBuilder()
        
        let eventsViewController = eventsModuleBuilder.build(output: self)
        navigationController.pushViewController(eventsViewController, animated: true)
        
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
}

extension EventsCoordinator: EventsModuleOutput {
    func usualEventsModuleWantsToOpenAddEventVC() {
        let eventsViewController = SuggestionViewController()
        eventsViewController.moduleOutput = self
        navigationController.pushViewController(eventsViewController, animated: true)
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
        //eventsViewController.output = self
        navigationController.pushViewController(eventsViewController, animated: true)
    }
    
    func openEventViewController() {
//        let eventsViewController = EventsPresenter(output: self)
//        eventsViewController.moduleOutput = self
//        navigationController.pushViewController(eventsViewController, animated: true)
    }
}
