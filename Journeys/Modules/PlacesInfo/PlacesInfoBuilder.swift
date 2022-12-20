//
//  PlacesIngoBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit

// MARK: - PlacesIngoModuleBuilder

final class PlacesInfoModuleBuilder {
    func build() -> UIViewController {

        let presenter = PlacesInfoPresenter()
        let viewController = PlacesInfoViewController()
        viewController.output = presenter
        presenter.view = viewController

        return viewController
    }
}
