//
//  TripsModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

// MARK: - Trips ModuleInput

protocol TripsModuleInput: AnyObject {
}

// MARK: - Trips ModuleOutput

protocol TripsModuleOutput: AnyObject {
    func tripsCollectionWantsToOpenExistingRoute(with trip: Trip)
    func tripsCollectionWantsToOpenNewRouteModule()
    
    func usualTripsModuleWantsToOpenSavedTrips()
    func savedTripsModuleWantsToClose()
}
