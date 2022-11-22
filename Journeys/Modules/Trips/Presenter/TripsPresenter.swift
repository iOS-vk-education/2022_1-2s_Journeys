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
    
    private var tripsData: [Trip]?


    //MARK: - Lifecycle

    init(interactor: TripsInteractorInput, router: TripsRouterInput) {
        self.interactor = interactor
        self.router = router
        loadTripsData()
        print(tripsData?.count)
    }
    
    private func loadTripsData() {
        tripsData = interactor.obtainDataFromSever()
    }
}

extension TripsPresenter: TripsModuleInput {
}

extension TripsPresenter: TripsViewOutput {
    func getCellData(for indexPath: IndexPath) -> TripCell.DisplayData {
        let curTripData = tripsData?[indexPath.row]
        let dates = DateFormatter.dayAndMonth.string(from: curTripData?.route.start ?? Date()) + "-"
        + DateFormatter.dayAndMonth.string(from: curTripData?.route.finish ?? Date())
        let arrow = "→"
        // TODO: Errors
        var routeString = (curTripData?.route.departureTown.city ?? "")
        for place in curTripData?.route.places ?? [] {
            routeString += arrow + place.location.city
        }
        return TripCell.DisplayData(picture: curTripData?.icon,
                             dates: dates,
                             route: routeString,
                             isInFavourites: curTripData?.isInfavourites ?? false)
    }
    
    func getTripCellsCount() -> Int {
        return tripsData?.count ?? 0
    }
    
    func didSelectCell(at indexpath: IndexPath) {
        moduleOutput.tripsCollectionWantsToOpenNewRouteCreating()
    }
}

extension TripsPresenter: TripsInteractorOutput {
}
