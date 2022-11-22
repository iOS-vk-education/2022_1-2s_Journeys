//
//  AddNewLocationBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import UIKit

// MARK: - AddNewLocationModuleBuilder

final class AddNewLocationModuleBuilder {
    func build(output: AddNewLocationModuleOutput) -> UIViewController {

        let presenter = AddNewLocationPresenter()
        let viewController = AddNewLocationViewController()
        presenter.view = viewController
        presenter.moduleOutput = output
        
        viewController.output = presenter

        return viewController
    }
}
