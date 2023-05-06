//
//  PlacesInfoRouter.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.04.2023.
//

import Foundation

final class PlacesInfoRouter: PlacesInfoRouterInput {
    
    weak var placesInfoViewController: TransitionHandlerProtocol?
    
    init(_ placesInfoViewController: PlacesInfoViewController? = nil) {
        self.placesInfoViewController = placesInfoViewController
    }
    
    func embedPlaceholder() {
        let placeHolderViewController = PacesInfoLoadingPlaceholderViewController()
        placesInfoViewController?.embedPlaceholder(placeHolderViewController)
    }
    
    func hidePlaceholder() {
        placesInfoViewController?.hidePlaceholder()
    }
}
