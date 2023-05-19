//
//  PlacesInfoInteractorIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.12.2022.
//

import Foundation

// MARK: - PlacesInfoInteractorModuleInput

protocol PlacesInfoInteractorInput: AnyObject {
    func loadData(for route: Route)
    func updateCurrencyRate(from oldCurrencyCode: String,
                            to newCurrencyCode: String,
                            amount: Float,
                            completion: @escaping (CurrencyRate) -> Void)
}

// MARK: - PlacesInfoInteractorModuleOutput

protocol PlacesInfoInteractorOutput: AnyObject {
    func getRoute() -> Route
    
    func didRecieveError(error: Error)
    func noCoordinates(for location: Location)
    func noWeatherForPlace(_ place: Place)
    func noPlacesInRoute()
    func didFetchWeatherData(_ weather: [WeatherWithLocation])
    func didFetchGeoData(_ placesWithGeoData: [PlaceWithGeoData])
    func didFetchCurrencyRates(_ locationsWithCurrencyRate: [LocationsWithCurrencyRate])
    func didFetchAllData()
}
