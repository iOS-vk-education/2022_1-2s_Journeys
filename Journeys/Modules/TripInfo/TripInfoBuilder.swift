//
//  TripInfoBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

import UIKit

// MARK: - TripInfoModuleBuilder

final class TripInfoModuleBuilder {
    func build() -> UIViewController {

        let viewController = TripInfoViewController()
        let presenter = TripInfoPresenter()
        presenter.view = viewController
        viewController.output = presenter

        return viewController
    }
}
