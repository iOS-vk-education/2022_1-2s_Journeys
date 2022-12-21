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
            switch result {
            case .failure(let error):
                print("Error: \(error)")
                
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let timezone = try decoder.decode(Timezone.self, from: data)
                    self?.getWeatherData(for: coordinates, timezone: timezone, place: place)
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
                print("Error: \(error)")
                
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let forecast = try decoder.decode(WeatherForecast.self, from: data)
                    let weather = strongSelf.generateWeatherModels(from: forecast)
                    strongSelf.output.didRecieveWeatherData(weather)
                } catch {
                    assertionFailure("\(error)")
                }
            }
        }
    }
    
    private func generateWeatherModels(from forecast: WeatherForecast) -> [Weather] {
        var weatherList: [Weather] = []
        let dailyWeather = forecast.dailyWeather
        for index in 0..<dailyWeather.date.count {
            let weather = Weather(date: dailyWeather.date[index],
                                  weatherCode: dailyWeather.weatherCode[index],
                                  temperatureMax: dailyWeather.temperatureMax[index],
                                  temperatureMin: dailyWeather.temperatureMin[index])
            weatherList.append(weather)
        }
        return weatherList
    }
}

extension PlacesInfoModel: PlacesInfoModelInput {
    func getRouteData(with identifyer: String) {
        let loc1 = Location(country: "Russia", city: "Moscow")
        let loc2 = Location(country: "Russia", city: "Kursk")
        let loc3 = Location(country: "Russia", city: "Anapa")
        let loc4 = Location(country: "Russia", city: "Perm")
        output.didRecieveRouteData(Route(id: "", departureLocation: loc1,
                                         places: [Place(location: loc2,
                                                        arrive: Date(),
                                                        depart: Date().addingTimeInterval(100000)),
                                                  Place(location: loc3,
                                                        arrive: Date().addingTimeInterval(100000),
                                                        depart: Date().addingTimeInterval(200000)),
                                                  Place(location: loc4,
                                                        arrive: Date().addingTimeInterval(200000),
                                                        depart: Date().addingTimeInterval(250000))]))
    }

    func getWeatherData(for place: Place) {
//        let request = requestFactory.getLocationCoordinates(city: place.location.city,
//                                                            country: place.location.country)
//        networkService.sendRequest(request) { [weak self] result in
//            switch result {
//            case .failure(let error):
//                print("Error: \(error)")
//            case .success(let data):
//                do {
//                    let decoder = JSONDecoder()
//                    let coordinatesMas = try decoder.decode([Coordinates].self, from: data)
//                    let coordinates = coordinatesMas[0]
//                    self?.getTimezone(for: coordinates, place: place)
//                } catch {
//                    assertionFailure("\(error)")
//                }
//            }
//        }
    }
}
