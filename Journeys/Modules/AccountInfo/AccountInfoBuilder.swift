//
//  AccountInfoBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import UIKit

// MARK: - AccountInfoModuleBuilder

final class AccountInfoModuleBuilder {
    func build(output: AccountInfoModuleOutput,
               firebaseService: FirebaseServiceProtocol) -> UIViewController {

        let viewController = AccountInfoViewController()
        let presenter = AccountInfoPresenter()
        let model = AccountInfoModel(firebaseService: firebaseService)
        
        model.output = presenter
        presenter.view = viewController
        presenter.model = model
        presenter.moduleOutout = output
        viewController.output = presenter

        return viewController
    }
}
