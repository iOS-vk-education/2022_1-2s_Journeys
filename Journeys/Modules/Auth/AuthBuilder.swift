//
//  AuthBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

import UIKit

// MARK: - AuthModuleBuilder

final class AuthModuleBuilder {
    func build(moduleType: AuthPresenter.ModuleType,
               output: AuthModuleOutput,
               firebaseService: FirebaseServiceProtocol) -> UIViewController {

        let presenter = AuthPresenter(moduleType: moduleType)
        let model = AuthModel(firebaseService: firebaseService)
        let viewController = AuthViewController()
        
        presenter.moduleOutput = output
        presenter.view = viewController
        presenter.model = model
        model.output = presenter
        viewController.output = presenter

        return viewController
    }
}
