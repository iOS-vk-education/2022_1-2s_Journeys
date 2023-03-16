//
//  SettingsModuleBuilder.swift
//  DrPillman
//
//  Created by puzzzik on 17/05/2022.
//

import UIKit

final class SettingsModuleBuilder {

    func build(firebaseService: FirebaseServiceProtocol, moduleOutput: SettingsModuleOutput) -> UIViewController {
        let viewController = SettingsViewController()
        let router = SettingsRouter()
        let interactor = SettingsInteractor()
        let notificationManager = NotificationsManager()
        let displayDataFactory = SettingsDisplayDataFactory(notificationsManager: notificationManager)

        let presenter = SettingsPresenter(interactor: interactor,
                                          router: router,
                                          displayDataFactory: displayDataFactory,
                                          appRateManager: AppRateManager(),
                                          notificationManager: notificationManager,
                                          moduleOutput: moduleOutput)
        presenter.view = viewController
        presenter.moduleOutput = moduleOutput
        interactor.output = presenter

        viewController.output = presenter

        return viewController
    }
}
