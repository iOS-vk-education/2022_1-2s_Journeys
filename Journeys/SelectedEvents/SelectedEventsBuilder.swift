//
//  SelectedEventsBuilder.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation
import UIKit

// MARK: - EventsModuleBuilder

final class SelectedEventsModuleBuilder {
    func build(output: SelectedEventsModuleOutput) -> UIViewController {
        let viewController = SelectedEventsViewController()
        let model = SelectedEventsModel()
        let presenter = SelectedEventsPresenter(view: viewController, model: model)
        viewController.output = presenter

        presenter.moduleOutput = output

        model.output = presenter

        return viewController
    }
}
