//
//  EventsBuilder.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 09.04.2023.
//

import UIKit

// MARK: - EventsModuleBuilder

final class EventsModuleBuilder {
    func build(output: EventsModuleOutput, latitude: Double, longitude: Double, zoom: Float) -> UIViewController {
        let viewController = EventsViewController()
        let model = EventsModel()
        let presenter = EventsPresenter(view: viewController, model: model)
        viewController.latitude = latitude
        viewController.longitude = longitude
        viewController.zoom = zoom
        viewController.output = presenter
        
        presenter.moduleOutput = output
        
        model.output = presenter
        
        return viewController
    }
}

