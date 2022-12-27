//
//  RouteBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import UIKit

// MARK: - RouteModuleBuilder

final class RouteModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol,
               with trip: TripWithRouteAndImage? = nil,
               output: RouteModuleOutput) -> UIViewController {

        let presenter = RoutePresenter(trip: trip)
        let viewController = RouteViewController()
        let model = RouteModel(firebaseService: firebaseService)
        
        presenter.view = viewController
        presenter.model = model
        presenter.moduleOutput = output
        
        model.output = presenter
    
        viewController.output = presenter

        return viewController
    }
}
