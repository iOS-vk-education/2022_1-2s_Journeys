//
//  PlacesInfoModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.12.2022.
//

import Foundation

// MARK: - PlacesInfo ModuleInput

protocol PlacesInfoModelInput: AnyObject {
    func getRouteData(with identifyer: String)
    func getWeatherData(for place: Place)
}

// MARK: - PlacesInfo ModuleOutput

protocol PlacesInfoModelOutput: AnyObject {
    func didRecieveRouteData(_ route: Route)
    func didRecieveWeatherData(_ weather: [Weather])
}
