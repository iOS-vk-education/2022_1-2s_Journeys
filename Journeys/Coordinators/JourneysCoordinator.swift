//
//  JourneysCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 09.11.2022.
//

import Foundation
import UIKit
import FirebaseAuth

final class JourneysCoordinator: CoordinatorProtocol {
    

    // MARK: Private Properties

    private let rootTabBarController: UITabBarController
    private var navigationController = UINavigationController()
    private let tabBarItemFactory: TabBarItemFactoryProtocol
    private let firebaseService: FirebaseServiceProtocol
    
    // MARK: Lifecycle

    let lock = NSLock()
    private let loadingViewGroup = DispatchGroup()
    init(rootTabBarController: UITabBarController,
         firebaseService: FirebaseServiceProtocol) {
        self.rootTabBarController = rootTabBarController
        self.firebaseService = firebaseService
        tabBarItemFactory = TabBarItemFactory()
    }

    // MARK: Public Methods

    func start() {
        let builder = TripsModuleBuilder()
        let viewController = builder.build(firebaseService: firebaseService, output: self)
        
        navigationController.setViewControllers([viewController], animated: false)
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
    
    func usualTripsModuleWantsToOpenSavedTrips(savedTrips: [TripWithRouteAndImage]) {
        let builder = TripsModuleBuilder()
        let tripsViewController = builder.build(firebaseService: firebaseService,
                                                output: self,
                                                tripsType: .saved,
                                                tripsData: savedTrips)
        navigationController.pushViewController(tripsViewController, animated: true)
    }
    
    func savedTripsModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
    
    func tripsCollectionWantsToOpenNewRouteModule() {
        let builder = RouteModuleBuilder()
        let newRouteViewController = builder.build(firebaseService: firebaseService, output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }
    
    func tripsCollectionWantsToOpenExistingRoute(with trip: TripWithRouteAndImage) {
        let builder = RouteModuleBuilder()
        let newRouteViewController = builder.build(firebaseService: firebaseService, with: trip, output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }
    
    func tripCollectionWantsToOpenTripInfoModule(trip: Trip, route: Route) {
        let builder = TripInfoModuleBuilder()
        let departureLocationViewController = builder.build(firebaseService: firebaseService,
                                                            output: self,
                                                            firstPageMode: .stuff,
                                                            trip: trip,
                                                            route: route)
        navigationController.pushViewController(departureLocationViewController, animated: true)
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
    
    func routeModuleWantsToOpenTripInfoModule(trip: Trip, route: Route) {
        let builder = TripInfoModuleBuilder()
        let departureLocationViewController = builder.build(firebaseService: firebaseService,
                                                            output: self,
                                                            firstPageMode: .info,
                                                            trip: trip,
                                                            route: route)
        navigationController.pushViewController(departureLocationViewController, animated: true)
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

extension JourneysCoordinator: TripInfoModuleOutput {
    func openAddStuffListModule(baggage: Baggage, stuffModuleInput: StuffModuleInput) {
        let builder = StuffListsModuleBuilder()
        let stuffListsViewController = builder.build(moduleType: .stuffListsAdding(baggage, stuffModuleInput),
                                                     firebaseService: firebaseService,
                                                     moduleOutput: self)
        if let sheet = stuffListsViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 28
        }
        navigationController.present(stuffListsViewController, animated: true)
    }
    // TODO: openEventsModule func after pull request #30 merge
    func openEventsModule(with coordinates: Coordinates) {
        let eventsModuleBuilder = EventsModuleBuilder()

        let eventsViewController = eventsModuleBuilder.build(output: self, latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 10, showSaveButton: false)
        navigationController.pushViewController(eventsViewController, animated: true)
    }
    
    func tripInfoModuleWantsToClose() {
        navigationController.popToViewController(navigationController.viewControllers[0], animated: true)
    }
}

extension JourneysCoordinator: StuffListsModuleOutput {
    func closeStuffListsModule() {
        navigationController.popViewController(animated: true)
    }
    
    func openCertainStuffListModule(for stuffList: StuffList?) {
        return
    }
}

extension JourneysCoordinator: EventsModuleOutput {
    func wantsToOpenAddEventVC() {
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
    
    func closeOpenSingleEventVCIfExists() {
        navigationController.dismiss(animated: true)
    }
}

extension JourneysCoordinator: SingleEventModuleOutput {
}
