//
//  NewTripPresenter.swift
//  Journeys
//
//  Created by Pritex007 on 03/11/2022.
//

// MARK: - NewTripPresenter

final class NewTripPresenter {
    // MARK: - Public Properties

    weak var view: NewTripViewInput!

}

extension NewTripPresenter: NewTripModuleInput {
}

extension NewTripPresenter: NewTripViewOutput {
}
