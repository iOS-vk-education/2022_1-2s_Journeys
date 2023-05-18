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
    
    private let weatherDataLoadQueue = DispatchQueue(label: "ru.journeys.weatherFethchQueue")
    private let weatherDataLoadDispatchGroup = DispatchGroup()
    
    private let currencyDataLoadQueue = DispatchQueue.global()
    private let currencyDataLoadDispatchGroup = DispatchGroup()
    
    private let dataSortQueue = DispatchQueue.global()
    private let dataSortDispatchGroup = DispatchGroup()
    
    private var isWeatherDataLoaded: Bool = false {
        didSet {
            checkIfAllDataIsLoaded()
        }
    }
    private var isCurrencyDataLoaded: Bool = false {
        didSet {
            checkIfAllDataIsLoaded()
        }
    }
    private var isEventsDataLoaded: Bool = false {
        didSet {
            checkIfAllDataIsLoaded()
        }
    }
    
    internal init() {
        self.requestFactory = NetworkRequestFactory()
        self.networkService = NetworkService(session: URLSession(configuration: .default))
    }
    
    private func checkIfAllDataIsLoaded() {
        if isWeatherDataLoaded, isCurrencyDataLoaded, isEventsDataLoaded {
            allDataLoaded()
        }
    }
}

// MARK: PlacesInfoInteractorInput
extension PlacesInfoInteractor: PlacesInfoInteractorInput {
    func loadData(for route: Route) {
        isWeatherDataLoaded = false
        isCurrencyDataLoaded = false
        isEventsDataLoaded = false
        
        geoData(for: route)
    }
    private func geoData(for route: Route) {
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
            guard let self else { return }
            self.sortGeoData(placesWithGeoData, route: route) { sortedGeoData in
                self.output?.didFetchGeoData(sortedGeoData)
                self.isEventsDataLoaded = true
                
                self.weatherData(placesWithGeoData: sortedGeoData)
                guard let currentCurrencyCode = Locale.current.currencyCode else { return }
                self.currencyCodesAndRate(for: currentCurrencyCode,
                                          placesWithGeoData: sortedGeoData)
                
            }
        }
    }
    
    private func weatherData(placesWithGeoData: [PlaceWithGeoData]) {
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
                        self.obtainWeather(placeWithGeoData: newPlace) { [weak self] weather in
                            weatherData.append(weather)
                            self?.weatherDataLoadDispatchGroup.leave()
                        }
                    } else {
                        self.obtainWeather(placeWithGeoData: placeWithGeoData) {  [weak self] weather in
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
            guard let self else { return }
            self.sortWeather(weatherData,
                             route: self.output.getRoute()) { sortedWeather in
                self.output?.didFetchWeatherData(sortedWeather)
                self.isWeatherDataLoaded = true
            }
        }
    }
    
    private func currencyCodesAndRate(for currentCurrencyCode: String, placesWithGeoData: [PlaceWithGeoData]) {
        var countryCodesDict: [String: [Location]] = [:]
        for placeWithGeoData in placesWithGeoData {
            if let currencyCode = Locale.currency[placeWithGeoData.countryCode]?.code {
                if countryCodesDict[currencyCode] != nil {
                    countryCodesDict[currencyCode]?.append(placeWithGeoData.place.location)
                } else {
                    countryCodesDict[currencyCode] = [placeWithGeoData.place.location]
                }
            }
        }
        currencyRate(for: countryCodesDict,
                     currentCurrencyCode: currentCurrencyCode,
                     amount: 1)
    }
    
    private func currencyRate(for currenciesAndLocations: [String: [Location]],
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
            guard let self else { return }
            self.sortCurrencyRate(locationsWithCurrencyRateList,
                                  route: self.output.getRoute()) { sortedCurrencyRates in
                self.output?.didFetchCurrencyRates(sortedCurrencyRates)
                self.isCurrencyDataLoaded = true
            }
        }
    }
    
    private func allDataLoaded() {
        output.didFetchAllData()
    }
    
    func updateCurrencyRate(from oldCurrencyCode: String,
                            to newCurrencyCode: String,
                            amount: Float,
                            completion: @escaping (CurrencyRate) -> Void) {
        let updateCurrencyRateDispatchQueue = DispatchQueue(label: "ru.Journeys.updateCurrencyRateDispatchQueue")
        updateCurrencyRateDispatchQueue.async {
            self.obtainCurrencyRate(from: oldCurrencyCode,
                                    to: newCurrencyCode,
                                    amount: amount) { currencyRate in
                completion(currencyRate)
            }
        }
    }
}

// MARK: Data obtain

extension PlacesInfoInteractor {
    private func obtainGeoData(for place: Place, completion: @escaping (GeoData) -> Void) {
        guard let request = requestFactory.getLocationData(city: place.location.city,
                                                           country: place.location.country) else {
            output?.didRecieveError(error: Errors.obtainDataError)
            return
        }
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.geoDataLoadDispatchGroup.leave()
                self.output.noCoordinates(for: place.location)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let geoDataMas = try decoder.decode([GeoData].self, from: data)
                    guard !geoDataMas.isEmpty else {
                        self.geoDataLoadDispatchGroup.leave()
                        self.output.noCoordinates(for: place.location)
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
    
    private func obtainWeather(placeWithGeoData: PlaceWithGeoData,
                               completion: @escaping (WeatherWithLocation) -> Void) {
        guard let request = requestFactory.getCoordinatesTimezone(placeWithGeoData.coordinates) else {
            output?.didRecieveError(error: Errors.obtainDataError)
            return
        }
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
        guard let request = requestFactory
            .getWeatherRequestForCoordinates(placeWithGeoData.coordinates,
                                             timezone: timezone,
                                             startDate: DateFormatter.fullDateWithDash.string(from: placeWithGeoData.place.arrive),
                                             endDate: DateFormatter.fullDateWithDash.string(from: placeWithGeoData.place.depart)) else {
            output?.didRecieveError(error: Errors.obtainDataError)
            return
        }
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
    
    private func obtainCurrencyRate(from currentCurrency: String,
                                    to localCurrency: String,
                                    amount: Float, completion: @escaping (CurrencyRate) -> Void) {
        guard let request = requestFactory.getCurrencyRate(from: currentCurrency,
                                                           to: localCurrency,
                                                           amount: amount) else {
            output?.didRecieveError(error: Errors.obtainDataError)
            return
        }
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

// MARK: Data Sort
extension PlacesInfoInteractor {
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
    
    private func sortWeather(_ weather: [WeatherWithLocation],
                             route: Route,
                             completion: @escaping ([WeatherWithLocation]) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            var sortedWeather: [WeatherWithLocation] = []
            for place in route.places {
                for curWeather in weather {
                    if curWeather.isMatchToPlace(place) {
                        sortedWeather.append(curWeather)
                        break
                    }
                }
            }
            completion(sortedWeather)
        }
    }
    
    private func sortGeoData(_ placesWithGeoData: [PlaceWithGeoData],
                             route: Route,
                             completion: @escaping ([PlaceWithGeoData]) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            var sortedGeoData: [PlaceWithGeoData] = []
            for place in route.places {
                for placeWithGeoData in placesWithGeoData {
                    if placeWithGeoData.place.location == place.location {
                        sortedGeoData.append(placeWithGeoData)
                        break
                    }
                }
            }
            completion(sortedGeoData)
        }
    }
    
    private func sortCurrencyRate(_ locationsWithCurrencyRate: [LocationsWithCurrencyRate],
                                  route: Route,
                                  completion: @escaping ([LocationsWithCurrencyRate]) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            var sortedCurrencyRate: [LocationsWithCurrencyRate] = []
            for place in route.places {
                for currencyRate in locationsWithCurrencyRate {
                    if currencyRate.locations.first == place.location {
                        sortedCurrencyRate.append(currencyRate)
                        break
                    }
                }
            }
            completion(sortedCurrencyRate)
        }
    }
}
