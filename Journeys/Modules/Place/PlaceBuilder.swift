//
//  PlaceBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import UIKit

// MARK: - PlaceModuleBuilder

final class PlaceModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol,
               output: PlaceModuleOutput,
               place: Place?,
               placeIndex: Int,
               routeModuleInput: RouteModuleInput) -> UIViewController {

        let presenter = PlacePresenter(place: place, placeIndex: placeIndex, routeModuleInput: routeModuleInput)
        let viewController = PlaceViewController()
        let model = PlaceModel(firebaseService: firebaseService)
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.moduleOutput = output
        presenter.model = model
        
        model.output = presenter

        return viewController
    }
}
