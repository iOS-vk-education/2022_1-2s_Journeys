//
//  EventsCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.12.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import SafariServices

final class EventsCoordinator: CoordinatorProtocol, SingleEventModuleOutput {
    
    
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
}

extension EventsCoordinator: EventsModuleOutput {
    func closeOpenSingleEventVCIfExists() {
        navigationController.dismiss(animated: true)
    }
    
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
    
    func openAddingEventViewController(coordinates: GeoPoint?, address: String?, event: Event?) {
        let builder = AddingModuleBuilder()
        let viewController = builder.build(output: self, coordinates: coordinates, address: address, event: event, moduleType: .adding, image: nil)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func wantsToOpenSingleEventVC(id: String) {
        let builder = SingleEventModuleBuilder()

        let viewController = builder.build(output: self, id: id)
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersGrabberVisible = true
        }
        
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    func wantsToOpenSelectedEvents() {
        let builder = SelectedEventsModuleBuilder()
        let viewController = builder.build(output: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension EventsCoordinator: SelectedEventsModuleOutput {
    func wantsToOpenEditingVC(event: Event, image: UIImage?) {
        let builder = AddingModuleBuilder()
        let viewController = builder.build(output: self, coordinates: nil, address: event.address, event: event, moduleType: .editing, image: image)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func closeSelectedEvents() {
        navigationController.popToRootViewController(animated: false)
    }
}


extension EventsCoordinator: AddingModuleOutput {
    func wantsToOpenEventsVC() {
        navigationController.popToRootViewController(animated: false)
    }
    func backToSuggestionVC() {
        navigationController.popViewController(animated: true)
    }
}
