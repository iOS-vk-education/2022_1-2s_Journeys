//
//  TripsBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsModuleBuilder

final class TripsModuleBuilder {
    func build(output: TripsModuleOutput) -> UIViewController {

        let fb = FirebaseService()
        fb.obtainRoute(with: "ptlOYsXo6TFTuvemhSpH") {result in
            switch result {
            case .failure(let error):
                assertionFailure("\(error)")
            case .success(let route):
                print(route)
            }
        }
        
        let router = TripsRouter()
        let interactor = TripsInteractor()
        let presenter = TripsPresenter(interactor: interactor, router: router)
        
        presenter.moduleOutput = output
        interactor.output = presenter

        let viewController = TripsViewController()
        viewController.output = presenter
        presenter.view = viewController

        return viewController
    }
}
