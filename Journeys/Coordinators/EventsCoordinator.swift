//
//  EventsCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.12.2022.
//

import Foundation
import UIKit
import FirebaseFirestore


final class EventsCoordinator: CoordinatorProtocol {
    
    // MARK: Private Properties
    
    private let rootTabBarController: UITabBarController
    private var navigationController = UINavigationController()
    private let tabBarItemFactory: TabBarItemFactoryProtocol
    private let firebaseService: FirebaseServiceProtocol
    private var bottomSheetTransitioningDelegate: UIViewControllerTransitioningDelegate?
    
    // MARK: Lifecycle
    
    init(rootTabBarController: UITabBarController, firebaseService: FirebaseServiceProtocol) {
        self.rootTabBarController = rootTabBarController
        self.firebaseService = firebaseService
        tabBarItemFactory = TabBarItemFactory()
    }
    // MARK: Public Methods
    func start() {
        let eventsModuleBuilder = EventsModuleBuilder()
        
        let eventsViewController = eventsModuleBuilder.build(output: self, latitude: 55, longitude: 37, zoom: 1)
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
    
    func openSuggestionViewController() {
        let eventsViewController = SuggestionViewController()
        eventsViewController.moduleOutput = self
        navigationController.pushViewController(eventsViewController, animated: true)
    }
    func openEventViewController() {
        navigationController.popViewController(animated: true)
    }
    func wantsToOpenAddEventVC() {
        let eventsViewController = SuggestionViewController()
        eventsViewController.moduleOutput = self
        navigationController.pushViewController(eventsViewController, animated: true)
    }
    
    func openAddingEventViewController(coordinates: GeoPoint, address: String) {
        let builder = AddingModuleBuilder()

        let viewController = builder.build(output: self, coordinates: coordinates, address: address)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func wantsToOpenSingleEventVC() {
//        let viewController = SingleEventViewController(initialHeight: 300)
//        viewController.modalPresentationStyle = .custom
//        bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()
//        viewController.transitioningDelegate = bottomSheetTransitioningDelegate
//        navigationController.present(viewController, animated: true)
        let vc = SingleEventViewController()
             
               // 2
               if let sheet = vc.sheetPresentationController {
                   // 3
                   sheet.detents = [.medium(), .large()]
                   // 4
                   sheet.largestUndimmedDetentIdentifier = .medium
                   // 5
                   sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                   // 6
                   sheet.prefersGrabberVisible = true
               }
        navigationController.present(vc, animated: true)
    }
}



extension EventsCoordinator: AddingModuleOutput {
    func wantsToOpenEventsVC() {
        navigationController.popViewController(animated: false)
        navigationController.popViewController(animated: false)
        navigationController.popViewController(animated: false)
        let eventsModuleBuilder = EventsModuleBuilder()
        
        let eventsViewController = eventsModuleBuilder.build(output: self, latitude: 55, longitude: 37, zoom: 1)
        navigationController.pushViewController(eventsViewController, animated: false)
    }
    func backToSuggestionVC() {
        navigationController.popViewController(animated: true)
    }
}
