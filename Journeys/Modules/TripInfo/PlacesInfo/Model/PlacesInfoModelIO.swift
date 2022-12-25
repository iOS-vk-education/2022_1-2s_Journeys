//
//  PlacesInfoModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.12.2022.
//

import Foundation

// MARK: - PlacesInfo ModuleInput

protocol PlacesInfoModelInput: AnyObject {
    func getWeatherData(for place: Place, index: Int)
}

// MARK: - PlacesInfo ModuleOutput

protocol PlacesInfoModelOutput: AnyObject {
    func didRecieveWeatherData(_ weatherData: WeatherWithLocation)
    func didRecieveError(error: Error)
    func noCoordunatesFoPlace(_ place: Place, index: Int)
}
