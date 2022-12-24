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
        let builder = TripsModuleBuilder()
        let tripsViewController = builder.build(firebaseService: firebaseService, output: self)

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
    func usualTripsModuleWantsToOpenSavedTrips() {
        let builder = TripsModuleBuilder()
        let newRouteViewController = builder.build(firebaseService: firebaseService, output: self, tripsViewControllerType: .saved)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }
    
    func savedTripsModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
    
    func tripsCollectionWantsToOpenNewRouteModule() {
        let builder = RouteModuleBuilder()
        let newRouteViewController = builder.build(firebaseService: firebaseService, output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }
    
    
    func tripsCollectionWantsToOpenExistingRoute(with trip: Trip) {
        let builder = RouteModuleBuilder()
        let newRouteViewController = builder.build(firebaseService: firebaseService, with: trip, output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }

}

extension JourneysCoordinator: RouteModuleOutput {
    func routeModuleWantsToOpenDepartureLocationModule(departureLocation: Location?,
                                                       routeModuleInput: RouteModuleInput) {
        let builder = DepartureLocationModuleBuilder()
        let departureLocationViewController = builder.build(output: self,
                                                            departureLocation: departureLocation,
                                                            routeModuleInput: routeModuleInput)
        navigationController.pushViewController(departureLocationViewController, animated: true)
    }
    func routeModuleWantsToOpenPlaceModule(place: Place?, placeIndex: Int, routeModuleInput: RouteModuleInput) {
        let builder = PlaceModuleBuilder()
        let placeViewController = builder.build(firebaseService: firebaseService,
                                                output: self,
                                                place: place,
                                                placeIndex: placeIndex,
                                                routeModuleInput: routeModuleInput)
        navigationController.pushViewController(placeViewController, animated: true)
    }
    
    func routeModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
}

extension JourneysCoordinator: DepartureLocationModuleOutput {
    func departureLocationModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
}

extension JourneysCoordinator: PlaceModuleOutput {
    func placeModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
}
