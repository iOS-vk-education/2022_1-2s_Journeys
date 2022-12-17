//
//  NewRouteCreatingBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import UIKit

// MARK: - NewRouteCreatingModuleBuilder

final class NewRouteCreatingModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol,
               with routId: String? = nil,
               output: NewRouteCreatingModuleOutput) -> UIViewController {

        let presenter = NewRouteCreatingPresenter(routeId: routId)
        let viewController = NewRouteCreatingViewController()
        let model = NewRouteCreatingModel(firebaseService: firebaseService)
        
        presenter.view = viewController
        presenter.model = model
        presenter.moduleOutput = output
        
        model.output = presenter
    
        viewController.output = presenter

        return viewController
    }
}
