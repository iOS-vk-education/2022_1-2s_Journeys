//
//  TripsRouter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

// MARK: - TripsRouter

final class TripsRouter: TripsRouterInput {
    
    weak var tripsViewController: TransitionHandlerProtocol?
    
    init(_ tripsViewController: TripsViewController? = nil) {
        self.tripsViewController = tripsViewController
    }
    
    func embedPlaceholder() {
        let placeholderViewController = PlaceholderViewController()
        tripsViewController?.embedPlaceholder(placeholderViewController)
    }
    
    func hidePlaceholder() {
        tripsViewController?.hidePlaceholder()
    }
}
