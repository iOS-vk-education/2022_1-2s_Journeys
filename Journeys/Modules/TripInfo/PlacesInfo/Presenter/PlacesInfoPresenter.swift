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
    weak var moduleOutput: PlacesInfoModuleOutput!
    let routeId: String
    var weather: [[Weather]] = []
//    var weather: [[Weather]] = [[Weather(date: "2022-12-01", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-02", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-03", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-04", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-05", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-06", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-07", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)],
//                                [Weather(date: "2022-12-08", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-09", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-10", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)],
//                                [Weather(date: "2022-12-08", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-09", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-10", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)],
//                                [Weather(date: "2022-12-01", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-02", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-03", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-04", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-05", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-06", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-07", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)],
//                                [Weather(date: "2022-12-08", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-09", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-10", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)],
//                                [Weather(date: "2022-12-01", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-02", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-03", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-04", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-05", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-06", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-07", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)]]
//    var weather: [[Weather]] = [[Weather(date: "2022-12-08", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                  Weather(date: "2022-12-09", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                  Weather(date: "2022-12-10", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)]]
//    var weather: [[Weather]] = [[Weather(date: "2022-12-01", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-02", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-03", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-04", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-05", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                Weather(date: "2022-12-06", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
////                                Weather(date: "2022-12-07", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)]]
//    var weather: [[Weather]] = [[Weather(date: "2022-12-01", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-02", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-03", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-04", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-05", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-06", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-07", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)],
//                                [Weather(date: "2022-12-08", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-09", weatherCode: 0, temperatureMax: 2, temperatureMin: 0),
//                                 Weather(date: "2022-12-10", weatherCode: 0, temperatureMax: 2, temperatureMin: 0)]]

    var route: Route?
    
    init(routeId: String) {
        self.routeId = routeId
    }
}

extension PlacesInfoPresenter: PlacesInfoModuleInput {
}

extension PlacesInfoPresenter: PlacesInfoViewOutput {
    func viewDidLoad() {
        model.getRouteData(with: routeId)
    }
    
    func getWeatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData {
        WeatherCollection.DisplayData(town: route?.places[row].location.city ?? "",
                                      cellsCount: getWeatherCollectionCellsCount(for: row))
    }
    
    func getWeatherCollectionCellsCount(for row: Int) -> Int {
        guard weather.indices.contains(row) else { return 0}
        return weather[row].count
    }
    
    func getWeatherCollectionCellDisplayData(collectionRow: Int, cellRow: Int) -> WeatherCell.DisplayData {
        WeatherCellDisplayDataFactory().displayData(weather: weather[collectionRow][cellRow])
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
    
    func getRoutelData() -> RouteCell.DisplayData? {
        let arrow: String = " → "
        guard let route = route else { return nil }
        var routeString: String = route.departureLocation.city
        for place in route.places {
            routeString += arrow + place.location.city
        }
        return RouteCell.DisplayData(route: routeString)
    }
    
    func getMainCollectionCellsCount(for section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return weather.count
        }
        return 0
    }
    
    func didTapExitButton() {
        moduleOutput.placesModuleWantsToClose()
    }
}

extension PlacesInfoPresenter: PlacesInfoModelOutput {
    func didRecieveRouteData(_ route: Route) {
        self.route = route
        view.reloadData()
        let group = DispatchGroup()
        for place in route.places {
            model.getWeatherData(for: place)
        }
    }
    
    func didRecieveWeatherData(_ weather: [Weather]) {
        self.weather.append(weather)
        view.reloadData()
    }
}
