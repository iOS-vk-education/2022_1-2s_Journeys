//
//  TripsBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsModuleBuilder

final class TripsModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol, output: TripsModuleOutput) -> UIViewController {
        
        let router = TripsRouter()
        let interactor = TripsInteractor(firebaseService: firebaseService)
        let presenter = TripsPresenter(interactor: interactor, router: router)
        
        presenter.moduleOutput = output
        interactor.output = presenter

        let viewController = TripsViewController()
        viewController.output = presenter
        presenter.view = viewController

        return viewController
    }
}
