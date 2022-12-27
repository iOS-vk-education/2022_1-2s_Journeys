//
//  TripInfoBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

import UIKit

// MARK: - TripInfoModuleBuilder

final class TripInfoModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol,
               output: TripInfoModuleOutput,
               firstPageMode: FirstPageMode,
               trip: Trip,
               route: Route) -> UIViewController {

        let viewController = TripInfoViewController()
        let presenter = TripInfoPresenter(firstPageMode: firstPageMode, firebaseService: firebaseService, trip: trip, route: route)
        presenter.view = viewController
        viewController.output = presenter
        presenter.moduleOutput = output

        return viewController
    }
}
