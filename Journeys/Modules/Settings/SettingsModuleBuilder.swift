//
//  SettingsModuleBuilder.swift
//  DrPillman
//
//  Created by puzzzik on 17/05/2022.
//

import UIKit

final class SettingsModuleBuilder {

    func build(moduleOutput: SettingsModuleOutput) -> UIViewController {
        let viewController = SettingsViewController()
        let router = SettingsRouter()
        let interactor = SettingsInteractor()

        let presenter = SettingsPresenter(interactor: interactor,
                                          router: router,
                                          appRateManager: AppRateManager(),
                                          moduleOutput: moduleOutput)
        presenter.view = viewController
        presenter.moduleOutput = moduleOutput
        interactor.output = presenter

        viewController.output = presenter

        return viewController
    }
}
