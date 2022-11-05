//
//  TripsPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

// MARK: - TripsPresenter

final class TripsPresenter {
    // MARK: - Public Properties

    weak var view: TripsViewInput!

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
}

extension TripsPresenter: TripsInteractorOutput {
}