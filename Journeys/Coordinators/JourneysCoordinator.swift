//
//  JourneysCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 09.11.2022.
//

import Foundation
import UIKit

// MARK: - JourneysCoordinator

final class JourneysCoordinator: CoordinatorProtocol {

    // MARK: Private Properties
    private var navigationController: UINavigationController
    // MARK: Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Public Methods

    func start() {
        let builder = TripsModuleBuilder()
        let tripsViewController = builder.build(output: self)

        navigationController.setViewControllers([tripsViewController], animated: false)
    }

    // TODO: finish
    func finish() {
    }
}

// MARK: TripsModuleOutput

extension JourneysCoordinator: TripsModuleOutput {
    func tripsCollectionWantsToOpenTripPlaces(places: [Place]) {
        let builder = NewRouteCreatingModuleBuilder()
        let newRouteViewController = builder.build(places: places, output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }
    
    func tripsCollectionWantsToOpenExistingRoute() {
        return
    }
    
    func tripsCollectionWantsToOpenNewRouteModule() {
        let builder = NewRouteCreatingModuleBuilder()
        let newRouteViewController = builder.build(output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }

}

extension JourneysCoordinator: NewRouteCreatingModuleOutput {
    func newRouteCreationModuleWantsToOpenAddNewLocationModule(place: Place?){
        let builder = AddNewLocationModuleBuilder()
        let newLocaionViewController = builder.build(output: self, place: place)
        navigationController.pushViewController(newLocaionViewController, animated: true)
    }
    
    func newRouteCreationModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
}

extension JourneysCoordinator: AddNewLocationModuleOutput {
    func addNewLoctionModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
}
