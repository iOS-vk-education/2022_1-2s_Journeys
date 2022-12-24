//
//  RouteModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation
import UIKit

protocol RouteModelInput: AnyObject {
    func obtainRouteDataFromSever(with identifier: String)
    func storeRouteData(route: Route, tripImage: UIImage, tripId: String)
    func storeNewTrip(route: Route, tripImage: UIImage)
    func obtainTripImageFromServer(withURL imageURLString: String)
}

protocol RouteModelOutput: AnyObject, StoreNewTripOutput {
    func didFetchRouteData(data: Route)
    func didFetchTripImage(image: UIImage)
    func didRecieveError(error: Errors)
    func didSaveRouteData()
    
    func saveFinished()
    func saveError()
}
