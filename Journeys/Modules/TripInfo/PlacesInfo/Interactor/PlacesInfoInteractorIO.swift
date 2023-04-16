//
//  PlacesInfoInteractorIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.12.2022.
//

import Foundation

// MARK: - PlacesInfoInteractorModuleInput

protocol PlacesInfoInteractorInput: AnyObject {
    func weatherData(placesWithGeoData: [PlaceWithGeoData])
    func geoData(for route: Route)
    func currencyRate(for currenciesAndLocations: [String: [Location]],
                      currentCurrencyCode: String,
                      amount: Float)
}

// MARK: - PlacesInfoInteractorModuleOutput

protocol PlacesInfoInteractorOutput: AnyObject {
    func didRecieveError(error: Error)
    func noCoordunates(for location: Location)
    func noWeatherForPlace(_ place: Place)
    func noPlacesInRoute()
    func didFetchAllWeatherData(_ weather: [WeatherWithLocation])
    func didFetchGeoData(_ placesWithGeoData: [PlaceWithGeoData])
    func didFetchCurrencyRates(_ locationsWithCurrencyRate: [LocationsWithCurrencyRate])
}
