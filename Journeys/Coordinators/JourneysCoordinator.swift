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
    func tripsCollectionWantsToOpenNewRouteCreating() {
        let builder = NewRouteCreatingModuleBuilder()
        let newRouteViewController = builder.build(output: self)
        navigationController.pushViewController(newRouteViewController, animated: true)
    }

}

extension JourneysCoordinator: NewRouteCreatingModuleOutput {
    func newRouteCreationModuleWantsToClose() {
        navigationController.popViewController(animated: true)
    }
}
