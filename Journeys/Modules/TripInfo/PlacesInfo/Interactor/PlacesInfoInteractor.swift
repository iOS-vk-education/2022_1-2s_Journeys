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
    
    private let dataLoadQueue = DispatchQueue.global()
    private let dataLoadDispatchGroup = DispatchGroup()
    
    internal init() {
        self.requestFactory = NetworkRequestFactory()
        self.networkService = NetworkService(session: URLSession(configuration: .default))
    }
    
    private func obtainWeatherDataFromServer(for place: Place) {
        let request = requestFactory.getLocationCoordinates(city: place.location.city,
                                                            country: place.location.country)
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.dataLoadDispatchGroup.leave()
                self.output.noCoordunates(for: place.location)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let coordinatesMas = try decoder.decode([Coordinates].self, from: data)
                    guard !coordinatesMas.isEmpty else {
                        self.dataLoadDispatchGroup.leave()
                        self.output.noCoordunates(for: place.location)
                        return
                    }
                    let coordinates = coordinatesMas[0]
                    self.getTimezone(for: coordinates, place: place)
                } catch {
                    assertionFailure("\(error)")
                }
            }
        }
    }
    
    private func getTimezone(for coordinates: Coordinates, place: Place) {
        let request = requestFactory.getCoordinatesTimezone(coordinates)
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.dataLoadDispatchGroup.leave()
                self.output.didRecieveError(error: error)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let timezone = try decoder.decode(Timezone.self, from: data)
                    self.getWeatherData(for: coordinates, timezone: timezone, place: place)
                } catch {
                    self.dataLoadDispatchGroup.leave()
                    assertionFailure("\(error)")
                }
            }
        }
    }
    
    private func getWeatherData(for coordinates: Coordinates, timezone: Timezone, place: Place) {
        let request = requestFactory.getWeatherRequestForCoordinates(coordinates,
                                                                     timezone: timezone,
                                                                     startDate: DateFormatter.fullDateWithDash.string(from: place.arrive),
                                                                     endDate: DateFormatter.fullDateWithDash.string(from: place.depart))
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.dataLoadDispatchGroup.leave()
                self.output.didRecieveError(error: error)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let forecast = try decoder.decode(WeatherForecast.self, from: data)
                    let weather = self.generateWeatherData(from: forecast, location: place.location)
                    self.output.didRecieveWeatherData(weather)
                    self.dataLoadDispatchGroup.leave()
                } catch {
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
}

extension PlacesInfoInteractor: PlacesInfoInteractorInput {
    
    func weatherData(for route: Route) {
        guard !route.places.isEmpty else {
            output?.noPlacesInRoute()
            return
        }
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 15
        guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else { return }
        
        for place in route.places {
            dataLoadDispatchGroup.enter()
            dataLoadQueue.async(group: dataLoadDispatchGroup) { [weak self] in
                guard let self else { return }
                if place.arrive < futureDate {
                    if place.depart > futureDate {
                        let newPlace = Place(location: place.location, arrive: place.arrive, depart: futureDate)
                        self.obtainWeatherDataFromServer(for: newPlace)
                    } else {
                        self.obtainWeatherDataFromServer(for: place)
                    }
                } else {
                    self.output.noWeatherForPlace(place)
                    self.dataLoadDispatchGroup.leave()
                }
            }
        }
        dataLoadDispatchGroup.notify(queue: dataLoadQueue) { [weak self] in
            self?.output?.didFetchAllWeatherData()
        }
    }
}
