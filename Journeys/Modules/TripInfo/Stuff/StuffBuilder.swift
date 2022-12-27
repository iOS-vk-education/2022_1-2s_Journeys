//
//  StuffBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

import UIKit

// MARK: - StuffModuleBuilder

final class StuffModuleBuilder {
    func build(output: StuffModuleOutput, firebaseService: FirebaseServiceProtocol, baggageId: String) -> UIViewController {

        let viewController = StuffViewController()
        let presenter = StuffPresenter(baggageId: baggageId)
        viewController.output = presenter
        let model = StuffModel(firebaseService: firebaseService)
        presenter.view = viewController
        presenter.model = model
        presenter.moduleOutput = output
        model.output = presenter

        return viewController
    }
}
