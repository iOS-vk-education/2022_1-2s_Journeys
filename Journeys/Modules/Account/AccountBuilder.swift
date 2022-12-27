//
//  AccountBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import UIKit

// MARK: - AccountModuleBuilder

final class AccountModuleBuilder {
    func build(output: AccountModuleOutput,
               firebaseService: FirebaseServiceProtocol) -> UIViewController {

        let viewController = AccountViewController()
        let presenter = AccountPresenter()
        let model = AccountModel(firebaseService: firebaseService)
        
        model.output = presenter
        presenter.view = viewController
        presenter.model = model
        presenter.moduleOutout = output
        viewController.output = presenter

        return viewController
    }
}
