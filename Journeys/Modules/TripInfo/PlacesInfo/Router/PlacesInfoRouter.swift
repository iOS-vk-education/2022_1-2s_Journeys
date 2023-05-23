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
        let placeHolderViewController = PlacesInfoLoadingPlaceholderViewController()
        placesInfoViewController?.embedPlaceholder(placeHolderViewController)
    }
    
    func showPlaceholder() {
        placesInfoViewController?.showPlaceholder()
    }
    
    func hidePlaceholder() {
        placesInfoViewController?.hidePlaceholder()
    }
}
