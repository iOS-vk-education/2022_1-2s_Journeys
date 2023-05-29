//
//  TripsModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

// MARK: - Trips ModuleInput

protocol TripsModuleInput: AnyObject {
    func somethingWasChanged()
    func isDataLoaded() -> Bool
    func changedTrip(_ trip: Trip)
    func deletTrip(trip: Trip)
}

// MARK: - Trips ModuleOutput

protocol TripsModuleOutput: AnyObject {
    func tripsCollectionWantsToOpenExistingRoute(with trip: TripWithRouteAndImage)
    func tripsCollectionWantsToOpenNewRouteModule()
    func usualTripsModuleWantsToOpenSavedTrips(savedTrips: [TripWithRouteAndImage])
    func savedTripsModuleWantsToClose()
    func tripCollectionWantsToOpenTripInfoModule(trip: Trip, route: Route)
}
