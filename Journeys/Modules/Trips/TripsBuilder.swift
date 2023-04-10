//
//  TripsBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsModuleBuilder

final class TripsModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol,
               output: TripsModuleOutput,
               tripsType: TripsType = .all) -> UIViewController {
        let viewController = TripsViewController()
        let interactor = TripsInteractor(firebaseService: firebaseService)
        let router = TripsRouter(viewController)
        let presenter = TripsPresenter(interactor: interactor,
                                       router: router,
                                       tripsType: tripsType)
        
        presenter.moduleOutput = output
        interactor.output = presenter
        
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
