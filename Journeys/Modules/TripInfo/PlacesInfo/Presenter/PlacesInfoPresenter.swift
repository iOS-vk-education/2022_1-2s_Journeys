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
