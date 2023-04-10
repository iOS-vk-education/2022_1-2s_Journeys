//
//  PlacesInfoInteractorIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.12.2022.
//

import Foundation

// MARK: - PlacesInfoInteractorModuleInput

protocol PlacesInfoInteractorInput: AnyObject {
    func weatherData(for route: Route)
}

// MARK: - PlacesInfoInteractorModuleOutput

protocol PlacesInfoInteractorOutput: AnyObject {
    func didRecieveWeatherData(_ weatherData: WeatherWithLocation)
    func didRecieveError(error: Error)
    func noCoordunates(for location: Location)
    func noWeatherForPlace(_ place: Place)
    func noPlacesInRoute()
    func didFetchAllWeatherData()
}
