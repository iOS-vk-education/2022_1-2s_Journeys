//
//  NewTripBuilder.swift
//  Journeys
//
//  Created by Pritex007 on 03/11/2022.
//

import UIKit

// MARK: - NewTripModuleBuilder

final class NewTripModuleBuilder {
    func build() -> UIViewController {

        let viewController = NewTripViewController()
        let presenter = NewTripPresenter()
        presenter.view = viewController
        viewController.output = presenter

        return viewController
    }
}
