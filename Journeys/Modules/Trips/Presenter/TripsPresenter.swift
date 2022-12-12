//
//  TripsPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation
import UIKit

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
        interactor.obtainTripsDataFromSever()
    }
    
    private func tripDisplayData(trip: Trip) -> TripCell.DisplayData? {
        let arrow = "→"
        
        var datesString: String? = nil
        var routeString: String = ""
        var tripDisplayData: TripCell.DisplayData
        
        guard let route = loadRoute(with: trip.routeId),
              let image = loadTripImage(for: trip.imageURLString)
        else {
            didRecieveError(error: .obtainDataError)
            return nil
        }
        if let startDate = route.places.first?.arrive,
           let endDate = route.places.last?.depart {
            datesString = DateFormatter.dayAndMonth.string(from: startDate) + "-"
            + DateFormatter.dayAndMonth.string(from: endDate)
        }
        routeString += route.departureLocation.city
        
        for place in route.places {
            routeString += arrow + place.location.city
        }
        
        tripDisplayData = TripCell.DisplayData(picture: image, dates: datesString, route: routeString, isInFavourites: trip.isInfavourites)
        
        return tripDisplayData
    }
    
    private func loadRoute(with identifier: String) -> Route? {
        var route: Route?
        interactor.obtainRouteDataFromSever(with: identifier) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let routeResult):
                route = routeResult
            case .failure(let error):
                assertionFailure("Error while obtaining route data from server: \(error.localizedDescription)")
                strongSelf.didRecieveError(error: .obtainDataError)
            }
        }
        return route
    }
    
    private func loadTripImage(for imageURLString: String) -> UIImage? {
        var resultImage: UIImage?
        interactor.obtainTripImageFromServer(for: imageURLString) { [weak self] imageResult in
            guard let strongSelf = self else { return }
            
            switch imageResult {
            case .success(let image):
                resultImage = image
            case .failure(let error):
                assertionFailure("Error while obtaining trips image from server: \(error.localizedDescription)")
                strongSelf.didRecieveError(error: .obtainDataError)
            }
        }
        return resultImage
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
            moduleOutput.tripsCollectionWantsToOpenExistingRoute(with: tripsData[indexpath.item].routeId)
        }
    }
}

extension TripsPresenter: TripsInteractorOutput {
    func didRecieveError(error: Errors) {
//        view.sho
    }
    
    func didFetchTripsData(data: [Trip]) {
        tripsData = data
    }
    
}
