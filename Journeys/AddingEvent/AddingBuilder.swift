//
//  AddingBuilder.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 03.05.2023.
//

import UIKit
import FirebaseFirestore
// MARK: - EventsModuleBuilder

final class AddingModuleBuilder {
    func build(output: AddingModuleOutput, coordinates: GeoPoint, address: String) -> UIViewController {
        let viewController = AddingEventViewController()
        viewController.coordinates = coordinates
        viewController.address = address
        let model = AddingModel()
        let presenter = AddingPresenter(view: viewController, model: model)

        viewController.output = presenter

        presenter.moduleOutput = output

        model.output = presenter

        return viewController
    }
}
