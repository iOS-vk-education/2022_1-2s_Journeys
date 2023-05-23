//
//  PlacesIngoBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit

// MARK: - PlacesIngoModuleBuilder

final class PlacesInfoModuleBuilder {
    func build(output: PlacesInfoModuleOutput, route: Route) -> UIViewController {
        
        let interactor = PlacesInfoInteractor()
        let viewController = PlacesInfoViewController()
        let router = PlacesInfoRouter(viewController)
        let presenter = PlacesInfoPresenter(interactor: interactor,
                                            router: router,
                                            route: route)
        viewController.output = presenter
        presenter.view = viewController
        
        presenter.moduleOutput = output
        interactor.output = presenter
        
        return viewController
    }
}
