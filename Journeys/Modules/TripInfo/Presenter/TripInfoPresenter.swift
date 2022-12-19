//
//  TripInfoPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

// MARK: - TripInfoPresenter

final class TripInfoPresenter {
    // MARK: - Public Properties

    weak var view: TripInfoViewInput!

}

extension TripInfoPresenter: TripInfoModuleInput {
}

extension TripInfoPresenter: TripInfoViewOutput {
}
