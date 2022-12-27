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

    weak var view: PlacesInfoViewInput?
    var model: PlacesInfoModel!
    weak var moduleOutput: PlacesInfoModuleOutput?
    private var route: Route
    private var weather: [WeatherWithLocation] = []
    private var loadedeWeather: [WeatherWithLocation] = []
    
    private var weatherLocationsCount: Int?
    private var isAnyPlacesWithWeather: Bool = false
    private var isAnyPlaces: Bool = false
    private var isDataLoaded: Bool = false
    private var dataToLoadCount: Int
    
    init(route: Route) {
        self.route = route
        if route.places.count > 0 {
            isAnyPlaces = true
        }
        dataToLoadCount = route.places.count
    }
    
    private func sortWeather() {
        var sortedWeather: [WeatherWithLocation] = []
        for place in route.places {
            for curWeather in loadedeWeather {
                if curWeather.location.city == place.location.city &&
                    curWeather.location.country == place.location.country {
                    sortedWeather.append(curWeather)
                }
            }
        }
        loadedeWeather = sortedWeather
    }
    
    private func showLoadingView() {
        view?.showLoadingView()
    }
    private func hideLoadingView() {
        view?.hideLoadingView()
    }

    private func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    private func dataLoaded() {
        sortWeather()
        weather = loadedeWeather
        view?.reloadData()
        hideLoadingView()
    }
}

extension PlacesInfoPresenter: PlacesInfoModuleInput {
}

extension PlacesInfoPresenter: PlacesInfoViewOutput {
    func viewDidLoad() {
        showLoadingView()
        for place in route.places {
            let currentDate = Date()
            var dateComponent = DateComponents()
            dateComponent.day = 15
            if let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) {
                if place.arrive < futureDate {
                    model.getWeatherData(for: place)
                }
            }
        }
    }
    
    func isEmptyCellNeed() -> Bool {
        if !isAnyPlaces || !isAnyPlacesWithWeather {
            return true
        }
        return false
    }
    
    func getEmptyCellData() -> String {
        if !isAnyPlaces {
            return "Не выбрано мест пребывания"
        } else if !isAnyPlacesWithWeather && isDataLoaded {
            return "Нет метео данных для выбранных городов или дат"
        }
        return ""
    }
    
    func getRouteCellHeight() -> CGFloat {
        return 0.0
    }
    
    func getMainCollectionCellsCount(for section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if weather.count == 0 {
                return 1
            }
            return weather.count
        }
        return 0
    }
    
    func getWeatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData? {
        guard weather.indices.contains(row) == true else { return nil }
        return WeatherCollection.DisplayData(town: weather[row].location.city)
    }
    
    func getWeatherCollectionCellsCount(for indexPath: IndexPath) -> Int {
        guard weather.indices.contains(indexPath.row) == true else { return 0 }
        return weather[indexPath.row].weather.count
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
    func noCoordunates() {
        dataToLoadCount -= 1
        if dataToLoadCount == 0 {
            isDataLoaded = true
            dataLoaded()
        }
    }
    
    func didRecieveError(error: Error) {
        dataToLoadCount -= 1
        view?.showAlert(title: "Ошибка", message: "Возникла ошибка при загрузке данных")
    }
    
    func didRecieveWeatherData(_ weatherData: WeatherWithLocation) {
        self.loadedeWeather.append(weatherData)
        isAnyPlacesWithWeather = true
        dataToLoadCount -= 1
        if dataToLoadCount == 0 {
            isDataLoaded = true
            dataLoaded()
        }
    }
}
