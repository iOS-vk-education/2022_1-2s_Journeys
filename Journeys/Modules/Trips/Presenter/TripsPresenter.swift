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
        tripsData = interactor.obtainTripsDataFromSever()
    }
    
    private func tripDisplayData(trip: Trip) -> TripCell.DisplayData? {
        let arrow = "→"
        
        var datesString: String? = nil
        var routeString: String = ""
        var tripDisplayData: TripCell.DisplayData
        
        guard let route = interactor.obtainRouteDataFromSever(with: trip.routeId),
              let departureLocation = interactor.obtainLocationDataFromSever(with: route.departureTownLocationId),
              let image = interactor.obtainTripImageFromServer(for: trip)
        else {
            return nil
        }
        if let startDate = route.places.first?.arrive,
           let endDate = route.places.last?.depart {
            datesString = DateFormatter.dayAndMonth.string(from: startDate) + "-"
            + DateFormatter.dayAndMonth.string(from: endDate)
        }
        routeString += departureLocation.city
        
        for place in route.places {
            guard let location = interactor.obtainLocationDataFromSever(with: place.locationId) else {
                return nil
            }
            routeString += arrow + location.city
        }
        
        tripDisplayData = TripCell.DisplayData(picture: image, dates: datesString, route: routeString, isInFavourites: trip.isInfavourites)
        
        return tripDisplayData
    }
}



extension TripsPresenter: TripsModuleInput {
}

extension TripsPresenter: TripsViewOutput {
    
    func getCellData(for id: Int) -> TripCell.DisplayData? {
        let trip = tripsData[id]
        return tripDisplayData(trip: trip)
    }
    
    func getTripCellsCount() -> Int {
        return tripsData.count
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
