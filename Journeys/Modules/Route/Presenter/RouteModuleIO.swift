//
//  RouteModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//
import UIKit

// MARK: - Route ModuleInput

protocol RouteModuleInput: AnyObject {
    func updateRoutePlaces(place: Place, placeIndex: Int)
    func updateRouteDepartureLocation(location: Location)
}

// MARK: - Route ModuleOutput

protocol RouteModuleOutput: AnyObject {
    func routeModuleWantsToClose()
    func routeModuleWantsToOpenPlaceModule(place: Place?, placeIndex: Int, routeModuleInput: RouteModuleInput)
    func routeModuleWantsToOpenDepartureLocationModule(departureLocation: Location?, routeModuleInput: RouteModuleInput)
    func routeModuleWantsToOpenTripInfoModule( trip: Trip, route: Route)
}
