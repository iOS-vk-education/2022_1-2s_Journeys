//
//  PlacesIngoModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import Foundation

// MARK: - PlacesInfoModel

final class PlacesInfoModel {
    private let requestFactory: NetworkRequestFactoryProtocol
    private let networkService: NetworkServiceProtocol
    weak var output: PlacesInfoModelOutput!
    
    internal init() {
        self.requestFactory = NetworkRequestFactory()
        self.networkService = NetworkService(session: URLSession(configuration: .default))
    }
    
    private func getTimezone(for coordinates: Coordinates, place: Place) {
        let request = requestFactory.getCoordinatesTimezone(coordinates)
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output.didRecieveError(error: error)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let timezone = try decoder.decode(Timezone.self, from: data)
                    self.getWeatherData(for: coordinates, timezone: timezone, place: place)
                } catch {
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
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output.didRecieveError(error: error)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let forecast = try decoder.decode(WeatherForecast.self, from: data)
                    let weather = strongSelf.generateWeatherData(from: forecast, location: place.location)
                    strongSelf.output.didRecieveWeatherData(weather)
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

extension PlacesInfoModel: PlacesInfoModelInput {

    func getWeatherData(for place: Place) {
        let request = requestFactory.getLocationCoordinates(city: place.location.city,
                                                            country: place.location.country)
        networkService.sendRequest(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output.didRecieveError(error: error)
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let coordinatesMas = try decoder.decode([Coordinates].self, from: data)
                    guard coordinatesMas.count > 0 else {
                        self.output.noCoordunatesFoPlace(place)
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
}
