//
//  NewRouteCreatingBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import UIKit

// MARK: - NewRouteCreatingModuleBuilder

final class NewRouteCreatingModuleBuilder {
    func build(places: [Place]? = nil, output: NewRouteCreatingModuleOutput) -> UIViewController {

        let presenter = NewRouteCreatingPresenter(places: places)
        let viewController = NewRouteCreatingViewController()
        presenter.view = viewController
        presenter.moduleOutput = output
    
        viewController.output = presenter

        return viewController
    }
}
