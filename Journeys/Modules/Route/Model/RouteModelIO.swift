//
//  RouteModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation

protocol RouteModelInput: AnyObject {
    func obtainRouteDataFromSever(with identifier: String)
    func storeRouteData(route: Route)
    func storeNewTrip(route: Route)
}

protocol RouteModelOutput: AnyObject, StoreNewTripOutput {
    func didFetchRouteData(data: Route)
    func didRecieveError(error: Errors)
    func didSaveRouteData()
    
    func saveFinished()
    func saveError()
}
