//
//  StuffBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

import UIKit

// MARK: - StuffModuleBuilder

final class StuffModuleBuilder {
    func build() -> UIViewController {

        let viewController = StuffViewController()
        let presenter = StuffPresenter()
        presenter.view = viewController
        viewController.output = presenter

        return viewController
    }
}
