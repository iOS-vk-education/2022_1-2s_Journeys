//
//  AccountBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

import UIKit

// MARK: - AccountModuleBuilder

final class AccountModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol, moduleOutput: AccountModuleOutput) -> UIViewController {
        let viewController = AccountViewController()
        let presenter = AccountPresenter(firebaseService: firebaseService,
                                         moduleOutput: moduleOutput)
        let model = AccountModel(firebaseService: firebaseService)
        
        presenter.view = viewController
        presenter.model = model
        model.output = presenter
        viewController.output = presenter
        
        return viewController
    }
}
