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
    private let firebaseService: FirebaseServiceProtocol
    // MARK: Lifecycle

    init(navigationController: UINavigationController, firebaseService: FirebaseServiceProtocol) {
        self.navigationController = navigationController
        self.firebaseService = firebaseService
    }

    // MARK: Public Methods

    func start() {
        let builder = TripsModuleBuilder()
        let tripsViewController = builder.build(firebaseService: firebaseService, output: self)

        navigationController.setViewControllers([tripsViewController], animated: false)
    }

    // TODO: finish
    func finish() {
    }
}

// MARK: TripsModuleOutput

extension JourneysCoordinator: TripsModuleOutput {
    func tripsCollectionWantsToOpenNewRouteModule() {
        let builder = NewRouteCreatingModuleBuilder()
        let newRouteViewController = builder.build(firebaseService: firebaseService, output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }
    
    
    func tripsCollectionWantsToOpenExistingRoute(with routId: String) {
        let builder = NewRouteCreatingModuleBuilder()
        let newRouteViewController = builder.build(firebaseService: firebaseService, with: routId, output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }

}

extension JourneysCoordinator: NewRouteCreatingModuleOutput {
    func newRouteCreationModuleWantsToOpenAddNewLocationModule(place: Place?){
        let builder = AddNewLocationModuleBuilder()
        let newLocaionViewController = builder.build(firebaseService: firebaseService, output: self, place: place)
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
