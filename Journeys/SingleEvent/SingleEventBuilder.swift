//
//  SingleEventBuilder.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 16.05.2023.
//

import UIKit

final class SingleEventModuleBuilder {
    func build(output: SingleEventModuleOutput, id: String) -> UIViewController {
        let viewController = SingleEventViewController()
        let model = SingleEventModel()
        let presenter = SingleEventPresenter(view: viewController, model: model, id: id)
        viewController.output = presenter
        presenter.id = id

        presenter.moduleOutput = output

        model.output = presenter

        return viewController
    }
}
