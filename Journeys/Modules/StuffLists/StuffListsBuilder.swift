//
//  StuffListsBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import UIKit

// MARK: - StuffListsModuleBuilder

final class StuffListsModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol,
               moduleOutput: StuffListsModuleOutput) -> UIViewController {

        let model = StuffListsModel(firebaseService: firebaseService)
        let viewController = StuffListsViewController()
        let presenter = StuffListsPresenter(model: model)
        viewController.output = presenter
        presenter.view = viewController
        presenter.moduleOutput = moduleOutput
        model.output = presenter

        return viewController
    }
}
