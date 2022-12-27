//
//  RouteModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation
import UIKit

protocol RouteModelInput: AnyObject {
    func storeRouteData(route: Route, tripImage: UIImage, tripId: String)
    func storeNewTrip(route: Route, tripImage: UIImage)
}

protocol RouteModelOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didSaveRouteData(route: Route)
    func didSaveData(trip: Trip, route: Route)
}
