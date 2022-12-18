//
//  StuffPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

// MARK: - StuffPresenter

final class StuffPresenter {
    // MARK: - Public Properties

    weak var view: StuffViewInput!

}

extension StuffPresenter: StuffModuleInput {
}

extension StuffPresenter: StuffViewOutput {
}
