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
    func build(output: AddingModuleOutput, coordinates: GeoPoint?, address: String?, event: Event?, moduleType: AddingPresenter.ModuleType, image: UIImage?) -> UIViewController {
        let viewController = AddingEventViewController()
        let model = AddingModel()
        let presenter = AddingPresenter(view: viewController, model: model, coordinates: coordinates, address: address, event: event, moduleType: moduleType, image: image)

        viewController.output = presenter

        presenter.moduleOutput = output

        model.output = presenter

        return viewController
    }
}
