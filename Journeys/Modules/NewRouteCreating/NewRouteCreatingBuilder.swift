//
//  NewRouteCreatingBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import UIKit

// MARK: - NewRouteCreatingModuleBuilder

final class NewRouteCreatingModuleBuilder {
    func build(with routId: String? = nil, output: NewRouteCreatingModuleOutput) -> UIViewController {

        let presenter = NewRouteCreatingPresenter(routeId: routId)
        let viewController = NewRouteCreatingViewController()
        let model = NewRouteCreatingModel()
        
        presenter.view = viewController
        presenter.model = model
        presenter.moduleOutput = output
    
        viewController.output = presenter

        return viewController
    }
}
