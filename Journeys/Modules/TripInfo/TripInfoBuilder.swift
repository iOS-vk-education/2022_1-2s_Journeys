//
//  TripInfoBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

import UIKit

// MARK: - TripInfoModuleBuilder

final class TripInfoModuleBuilder {
    func build(output: TripInfoModuleOutput, firstPageMode: FirstPageMode, routeId: String) -> UIViewController {

        let viewController = TripInfoViewController()
        let presenter = TripInfoPresenter(firstPageMode: firstPageMode, routeId: routeId)
        presenter.view = viewController
        viewController.output = presenter
        presenter.moduleOutput = output

        return viewController
    }
}
