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
    
    private var tripsData: [Trip] = []


    //MARK: - Lifecycle

    init(interactor: TripsInteractorInput, router: TripsRouterInput) {
        self.interactor = interactor
        self.router = router
        loadTripsData()
        print(tripsData.count)
    }
    
    private func loadTripsData() {
        tripsData = interactor.obtainDataFromSever()
    }
}

extension TripsPresenter: TripsModuleInput {
}

extension TripsPresenter: TripsViewOutput {
    
    func getCellData(for id: Int) -> TripCell.DisplayData {
        let curTripData = tripsData[id]
        let dates = DateFormatter.dayAndMonth.string(from: curTripData.start ?? Date()) + "-"
        + DateFormatter.dayAndMonth.string(from: curTripData.finish ?? Date())
        let arrow = "→"
        
        // TODO: Errors
        var routeString = (curTripData.route.departureTown.city)
        for place in curTripData.route.places {
            routeString += arrow + place.location.city
        }
        return TripCell.DisplayData(picture: curTripData.image,
                                    dates: dates,
                                    route: routeString,
                                    isInFavourites: curTripData.isInfavourites ?? false)
    }
    
    func getTripCellsCount() -> Int {
        return tripsData.count ?? 0
    }
    
    func didSelectCell(at indexpath: IndexPath) {
        switch indexpath.section {
        case 0:
            moduleOutput.tripsCollectionWantsToOpenNewRouteModule()
        default:
            moduleOutput.tripsCollectionWantsToOpenExistingRoute()
        }
    }
}

extension TripsPresenter: TripsInteractorOutput {
}
