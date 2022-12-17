//
//  NewRouteCreatingModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation

protocol NewRouteCreatingModelInput: AnyObject {
    func obtainRouteDataFromSever(with identifier: String)
}

protocol NewRouteCreatingModelOutput: AnyObject {
    func didFetchRouteData(data: Route)
    func didRecieveError(error: Errors)
}
