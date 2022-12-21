//
//  PlacesIngoBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit

// MARK: - PlacesIngoModuleBuilder

final class PlacesInfoModuleBuilder {
    func build(output: PlacesInfoModuleOutput, routeId: String) -> UIViewController {

        let presenter = PlacesInfoPresenter(routeId: routeId)
        let viewController = PlacesInfoViewController()
        let model = PlacesInfoModel()
        viewController.output = presenter
        model.output = presenter
        presenter.view = viewController
        presenter.model = model
        presenter.moduleOutput = output

        return viewController
    }
}
