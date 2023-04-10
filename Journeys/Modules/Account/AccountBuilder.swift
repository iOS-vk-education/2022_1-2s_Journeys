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
        presenter.view = viewController
        presenter.moduleOutput = moduleOutput
        
        viewController.output = presenter
        
        return viewController
    }
}
