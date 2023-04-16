//
//  PlacesInfoInteractor.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import Foundation

// MARK: - PlacesInfoInteractor

final class PlacesInfoInteractor {
    private let requestFactory: NetworkRequestFactoryProtocol
    private let networkService: NetworkServiceProtocol
    weak var output: PlacesInfoInteractorOutput!
    
    private let geoDataLoadQueue = DispatchQueue.global()
    private let geoDataLoadDispatchGroup = DispatchGroup()
    
    private let weatherDataLoadQueue = DispatchQueue.global()
    private let weatherDataLoadDispatchGroup = DispatchGroup()
    
    private let currencyDataLoadQueue = DispatchQueue.global()
    private let currencyDataLoadDispatchGroup = DispatchGroup()
    
    internal init() {
        self.requestFactory = NetworkRequestFactory()
        self.networkService = NetworkService(session: URLSession(configuration: .default))
    }
    
    private func obtainGeoData(for place: Place, completion: @escaping (GeoData) -> Void) {
        let request = requestFactory.getLocationData(city: place.location.city,
                                                            country: place.location.country)
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.geoDataLoadDispatchGroup.leave()
                self.output.noCoordunates(for: place.location)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let geoDataMas = try decoder.decode([GeoData].self, from: data)
                    guard !geoDataMas.isEmpty else {
                        self.geoDataLoadDispatchGroup.leave()
                        self.output.noCoordunates(for: place.location)
                        return
                    }
                    let geoData = geoDataMas[0]
                    completion(geoData)
                } catch {
                    assertionFailure("\(error)")
                }
            }
        }
    }
    
    private func obtainTimezone(placeWithGeoData: PlaceWithGeoData,
                                completion: @escaping (WeatherWithLocation) -> Void) {
        let request = requestFactory.getCoordinatesTimezone(placeWithGeoData.coordinates)
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.weatherDataLoadDispatchGroup.leave()
                self.output.didRecieveError(error: error)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let timezone = try decoder.decode(Timezone.self, from: data)
                    self.obtainWeatherData(placeWithGeoData: placeWithGeoData,
                                           timezone: timezone,
                                           completion: completion)
                } catch {
                    self.weatherDataLoadDispatchGroup.leave()
                    assertionFailure("\(error)")
                }
            }
        }
    }
    
    private func obtainWeatherData(placeWithGeoData: PlaceWithGeoData,
                                   timezone: Timezone,
                                   completion: @escaping (WeatherWithLocation) -> Void) {
        let request = requestFactory
            .getWeatherRequestForCoordinates(placeWithGeoData.coordinates,
                                             timezone: timezone,
                                             startDate: DateFormatter.fullDateWithDash.string(from: placeWithGeoData.place.arrive),
                                             endDate: DateFormatter.fullDateWithDash.string(from: placeWithGeoData.place.depart))
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.weatherDataLoadDispatchGroup.leave()
                self.output.didRecieveError(error: error)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let forecast = try decoder.decode(WeatherForecast.self, from: data)
                    let weather = self.generateWeatherData(from: forecast,
                                                           location: placeWithGeoData.place.location)
                    completion(weather)
                } catch {
                    self.weatherDataLoadDispatchGroup.leave()
                    assertionFailure("\(error)")
                }
            }
        }
    }
    
    private func generateWeatherData(from forecast: WeatherForecast, location: Location) -> WeatherWithLocation {
        var weatherList: [Weather] = []
        let dailyWeather = forecast.dailyWeather
        for index in 0..<dailyWeather.date.count {
            let weather = Weather(date: dailyWeather.date[index],
                                  weatherCode: dailyWeather.weatherCode[index],
                                  temperatureMax: dailyWeather.temperatureMax[index],
                                  temperatureMin: dailyWeather.temperatureMin[index])
            weatherList.append(weather)
        }
        return WeatherWithLocation(location: location, weather: weatherList)
    }
    
    private func obtainCurrencyRate(from currentCurrency: String,
                                    to localCurrency: String,
                                    amount: Float, completion: @escaping (CurrencyRate) -> Void) {
        let request = requestFactory.getCurrencyRate(from: currentCurrency,
                                                     to: localCurrency,
                                                     amount: amount)
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.currencyDataLoadDispatchGroup.leave()
                self.output.didRecieveError(error: error)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let currencyRate = try decoder.decode(CurrencyRate.self, from: data)
                    completion(currencyRate)
                } catch {
                    self.currencyDataLoadDispatchGroup.leave()
                    assertionFailure("\(error)")
                }
            }
        }
    }
}

extension PlacesInfoInteractor: PlacesInfoInteractorInput {
    
    func geoData(for route: Route) {
        guard !route.places.isEmpty else {
            output?.noPlacesInRoute()
            return
        }
        
        var placesWithGeoData: [PlaceWithGeoData] = []
        for place in route.places {
            geoDataLoadDispatchGroup.enter()
            geoDataLoadQueue.async(group: geoDataLoadDispatchGroup) { [weak self] in
                guard let self else { return }
                self.obtainGeoData(for: place) { [weak self] geoData in
                    guard let self else { return }
                    let placeWithGeoData = PlaceWithGeoData(place: place,
                                                            coordinates: Coordinates(from: geoData),
                                                            countryCode: geoData.countryCode)
                    placesWithGeoData.append(placeWithGeoData)
                    self.geoDataLoadDispatchGroup.leave()
                }
            }
        }
        geoDataLoadDispatchGroup.notify(queue: geoDataLoadQueue) { [weak self] in
            self?.output?.didFetchGeoData(placesWithGeoData)
        }
    }
    
    func weatherData(placesWithGeoData: [PlaceWithGeoData]) {
        guard !placesWithGeoData.isEmpty else {
            output?.noPlacesInRoute()
            return
        }
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 15
        guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else { return }
        
        var weatherData: [WeatherWithLocation] = []
        
        for placeWithGeoData in placesWithGeoData {
            weatherDataLoadDispatchGroup.enter()
            weatherDataLoadQueue.async(group: weatherDataLoadDispatchGroup) { [weak self] in
                guard let self else { return }
                if placeWithGeoData.place.arrive < futureDate {
                    if placeWithGeoData.place.depart > futureDate {
                        let newPlace = PlaceWithGeoData(place: Place(location: placeWithGeoData.place.location,
                                                                     arrive: placeWithGeoData.place.arrive,
                                                                     depart: futureDate),
                                                        coordinates: placeWithGeoData.coordinates,
                                                        countryCode: placeWithGeoData.countryCode)
                        self.obtainTimezone(placeWithGeoData: newPlace) { [weak self] weather in
                            weatherData.append(weather)
                            self?.weatherDataLoadDispatchGroup.leave()
                        }
                    } else {
                        self.obtainTimezone(placeWithGeoData: placeWithGeoData) {  [weak self] weather in
                            weatherData.append(weather)
                            self?.weatherDataLoadDispatchGroup.leave()
                        }
                    }
                } else {
                    self.output.noWeatherForPlace(placeWithGeoData.place)
                    self.weatherDataLoadDispatchGroup.leave()
                }
            }
        }
        weatherDataLoadDispatchGroup.notify(queue: weatherDataLoadQueue) { [weak self] in
            self?.output?.didFetchAllWeatherData(weatherData)
        }
    }
    
    func currencyRate(for currenciesAndLocations: [String: [Location]],
                      currentCurrencyCode: String,
                      amount: Float) {
        var locationsWithCurrencyRateList: [LocationsWithCurrencyRate] = []
        for (newCurrencyCode, locations) in currenciesAndLocations {
            currencyDataLoadDispatchGroup.enter()
            currencyDataLoadQueue.async(group: currencyDataLoadDispatchGroup) { [weak self] in
                guard let self else { return }
                self.obtainCurrencyRate(from: currentCurrencyCode,
                                        to: newCurrencyCode,
                                        amount: amount) { currencyRate in
                    locationsWithCurrencyRateList
                        .append(LocationsWithCurrencyRate(locations: locations,
                                                          currencyRate: currencyRate))
                    self.currencyDataLoadDispatchGroup.leave()
                }
            }
        }
        
        currencyDataLoadDispatchGroup.notify(queue: currencyDataLoadQueue) { [weak self] in
            self?.output.didFetchCurrencyRates(locationsWithCurrencyRateList)
        }
    }
}
