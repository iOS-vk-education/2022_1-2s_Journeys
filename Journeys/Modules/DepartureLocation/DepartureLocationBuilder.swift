//
//  DepartureLocationBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import UIKit

// MARK: - DepartureLocationModuleBuilder

final class DepartureLocationModuleBuilder {
    func build(output: DepartureLocationModuleOutput,
               departureLocation: Location?,
               routeModuleInput: RouteModuleInput) -> UIViewController {

        let presenter = DepartureLocationPresenter(departureLocation: departureLocation,
                                                   routeModuleInput: routeModuleInput)
        let viewController = DepartureLocationViewController()
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.moduleOutput = output

        return viewController
    }
}
