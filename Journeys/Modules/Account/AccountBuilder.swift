//
//  AccountBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import UIKit

// MARK: - AccountModuleBuilder

final class AccountModuleBuilder {
    func build(output: AccountModuleOutput) -> UIViewController {

        let viewController = AccountViewController()
        let presenter = AccountPresenter()
        presenter.view = viewController
        viewController.output = presenter

        return viewController
    }
}
