//
//  TripsBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsModuleBuilder

final class TripsModuleBuilder {
    func build() -> UIViewController {

        let viewController = TripsViewController()
        let router = TripsRouter()
        let interactor = TripsInteractor()


        let presenter = TripsPresenter(interactor: interactor, router: router)
        presenter.view = viewController

        interactor.output = presenter
        viewController.output = presenter

        return viewController
    }
}
