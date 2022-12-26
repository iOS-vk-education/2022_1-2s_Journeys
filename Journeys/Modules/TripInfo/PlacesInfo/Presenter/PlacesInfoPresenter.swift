//
//  PlacesIngoPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit

// MARK: - PlacesIngoPresenter

final class PlacesInfoPresenter {
    // MARK: - Public Properties

    weak var view: PlacesInfoViewInput!
    var model: PlacesInfoModel!
    weak var moduleOutput: PlacesInfoModuleOutput?
    private var route: Route
    private var weather: [WeatherWithLocation] = []
    
    private var isAnyPlacesForWeather: Bool = true
    
//    var loc1 = Location(country: "Russia", city: "Kursk")
//    var loc2 = Location(country: "Russia", city: "Anapa")
//    var loc3 = Location(country: "Russia", city: "Perm")
//    lazy var weather: [[Weather]] = [[Weather(date: "2022-12-01", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc1),
//                                 Weather(date: "2022-12-02", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc1),
//                                 Weather(date: "2022-12-03", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc1),
//                                 Weather(date: "2022-12-04", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc1),
//                                 Weather(date: "2022-12-05", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc1),
//                                      Weather(date: "2022-12-06", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc1),
//                                 Weather(date: "2022-12-07", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc1)],
//                                     [Weather(date: "2022-12-08", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc2),
//                                      Weather(date: "2022-12-09", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc2),
//                                      Weather(date: "2022-12-10", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc2)],
//                                     [Weather(date: "2022-12-08", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc3),
//                                      Weather(date: "2022-12-09", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc3),
//                                      Weather(date: "2022-12-10", weatherCode: 0, temperatureMax: 2, temperatureMin: 0, location: loc3)]]
//    var weather: [[Weather]] = [[Weather(date: "2022-12-08", weatherCode: 0, temperatureMax: 2, temperatureMin: 26),
//                                  Weather(date: "2022-12-09", weatherCode: 0, temperatureMax: 2, temperatureMin: 24),
//                                  Weather(date: "2022-12-10", weatherCode: 0, temperatureMax: 2, temperatureMin: 7)]]
//    var weather: [[Weather]] = [[Weather(date: "2022-12-01", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-02", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-03", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-04", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-05", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-06", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-07", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)]]
//    lazy var weather: [[Weather]] = [[Weather(date: "2022-12-01", weatherCode: 0, temperatureMax: -16, temperatureMin: -1006, location: route?.places[0].location)]]
    
    init(route: Route) {
        self.route = route
        if route.places.count == 0 {
            isAnyPlacesForWeather = false
        }
    }
    
    private func sortWeather() {
        var sortedWeather: [WeatherWithLocation] = []
        for place in route.places {
            for curWeather in weather {
                if curWeather.location.city == place.location.city &&
                    curWeather.location.country == place.location.country {
                    sortedWeather.append(curWeather)
                }
            }
        }
        weather = sortedWeather
    }
    
    private func showLoadingView() {
        moduleOutput?.showLoadingView()
    }
    private func hideLoadingView() {
        moduleOutput?.hideLoadingView()
    }
}

extension PlacesInfoPresenter: PlacesInfoModuleInput {
}

extension PlacesInfoPresenter: PlacesInfoViewOutput {
    func isAnyPlacesFowWeather() -> Bool {
        isAnyPlacesForWeather
    }
    func getRouteCellHeight() -> CGFloat {
        return 0.0
    }
    
    func viewDidLoad() {
        for place in route.places {
            let currentDate = Date()
            var dateComponent = DateComponents()
            dateComponent.day = 15
            if let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) {
                print(futureDate)
                if place.arrive > futureDate {
                    weather.append(WeatherWithLocation(location: place.location, weather: nil))
                } else {
                    model.getWeatherData(for: place)
                }
            }
        }
    }
    
    func getMainCollectionCellsCount(for section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if weather.count == 0 && !isAnyPlacesForWeather {
                return 1
            }
            print(weather.count)
            return weather.count
        }
        return 0
    }
    
    func getWeatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData? {
        guard weather.indices.contains(row) == true else { return nil }
        return WeatherCollection.DisplayData(town: weather[row].location.city)
    }
    
    func getWeatherCollectionCellsCount(for row: Int) -> Int {
        guard weather.indices.contains(row) == true else { return 0 }
        if weather[row].weather.count == 0 {
            return 1
        }
        return weather[row].weather.count
    }
    
    func getWeatherCollectionCellDisplayData(collectionRow: Int, cellRow: Int) -> WeatherCell.DisplayData? {
        guard weather.indices.contains(collectionRow) == true else { return nil }
        guard weather[collectionRow].weather.indices.contains(cellRow) == true else { return nil }
        return WeatherCellDisplayDataFactory().displayData(weather: weather[collectionRow].weather[cellRow])
    }
    
    func getHeaderText(for indexpath: IndexPath) -> String {
        switch indexpath.section {
        case 0:
            return "Маршрут"
        case 1:
            return "Погода"
        default:
            return ""
        }
    }
    
    func getRoutelData() -> ShortRouteCell.DisplayData? {
        let arrow: String = " → "
        var routeString: String = route.departureLocation.city
        for place in route.places {
            routeString += arrow + place.location.city
        }
        return ShortRouteCell.DisplayData(route: routeString)
    }
    
    func didTapExitButton() {
        moduleOutput?.placesModuleWantsToClose()
    }
}

extension PlacesInfoPresenter: PlacesInfoModelOutput {
    func noCoordunatesFoPlace(_ place: Place) {
        weather.append(WeatherWithLocation(location: place.location, weather: nil))
        view.reloadData()
    }
    
    func didRecieveError(error: Error) {
        
    }
    
    func didRecieveWeatherData(_ weatherData: WeatherWithLocation) {
        self.weather.append(weatherData)
        view.reloadData()
        hideLoadingView()
    }
}
