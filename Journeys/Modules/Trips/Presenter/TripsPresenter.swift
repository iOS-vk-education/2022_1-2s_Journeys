//
//  TripsPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation

// MARK: - TripsPresenter

final class TripsPresenter {
    // MARK: - Public Properties

    weak var view: TripsViewInput!
    weak var moduleOutput: TripsModuleOutput!

    // MARK: - Private Properties

    private let interactor: TripsInteractorInput
    private let router: TripsRouterInput


    //MARK: - Lifecycle

    init(interactor: TripsInteractorInput, router: TripsRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension TripsPresenter: TripsModuleInput {
}

extension TripsPresenter: TripsViewOutput {
    func didSelectCell(at indexpath: IndexPath) {
        moduleOutput.tripsCollectionWantsToOpenNewRouteCreating()
    }
    
}

extension TripsPresenter: TripsInteractorOutput {
}
