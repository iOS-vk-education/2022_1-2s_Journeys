//
//  PlacesInfoPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit

// MARK: - PlacesIngoPresenter

final class PlacesInfoPresenter {
    enum CellsType: Int, CaseIterable {
        case route
        case weather
        case currency
    }
    
    // MARK: - Public Properties

    weak var view: PlacesInfoViewInput?
    private let interactor: PlacesInfoInteractorInput
    private let router: PlacesInfoRouterInput
    weak var moduleOutput: PlacesInfoModuleOutput?
    private var route: Route
    private var weather: [WeatherWithLocation] = []
    
    private var isDataLoaded: Bool = false
    private var locationsWithoutCoordinatesList: [Location] = []
    
    
    init(interactor: PlacesInfoInteractorInput,
         router: PlacesInfoRouterInput,
         route: Route) {
        self.interactor = interactor
        self.router = router
        self.route = route
    }
    
    private func sortWeather() {
        var sortedWeather: [WeatherWithLocation] = []
        for place in route.places {
            for curWeather in weather {
                if curWeather.location.city == place.location.city &&
                    curWeather.location.country == place.location.country {
                    sortedWeather.append(curWeather)
                    break
                }
            }
        }
        weather = sortedWeather
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
    
    private func showNoCoordinatesAlert() {
        let locationsWithoutCoordinatesString: String = locationsWithoutCoordinatesList.compactMap( { $0.toString() } ).joined(separator: ", ")
        view?.showAlert(title: "Неизвестное место", message: "К сожалению, мы не смогли найти места из вашего маршрута: \(locationsWithoutCoordinatesString)")
    }
    
    private func embedRPlaceholder() {
        DispatchQueue.main.async { [weak self] in
            self?.router.embedPlaceholder()
        }
    }
    
    private func hidePlaceholder() {
        DispatchQueue.main.async { [weak self] in
            self?.router.hidePlaceholder()
        }
    }
}

extension PlacesInfoPresenter: PlacesInfoModuleInput {
}

extension PlacesInfoPresenter: PlacesInfoViewOutput {
    func viewDidLoad() {
        showLoadingView()
        interactor.weatherData(for: route)
    }
    
    func sectionsCount() -> Int {
        CellsType.allCases.count
    }
    
    func mainCollectionCellsCount(for section: Int) -> Int {
        guard isDataLoaded else { return 0 }
        guard CellsType.allCases.count > section else { return 0 }
        let section = CellsType.allCases[section]
        switch section {
        case .route, .currency: return 1
        case .weather: return weather.count == 0 ? 1 : weather.count
        default: return 0
        }
    }
    
    func getWeatherCollectionCellsCount(for indexPath: IndexPath) -> Int {
        guard isDataLoaded else { return 0 }
        guard weather.indices.contains(indexPath.row) == true else { return 0 }
        return weather[indexPath.row].weather.count
    }
    
    func mainCollectionCellType(for indexPath: IndexPath) -> CellsType? {
        guard isDataLoaded else { return nil }
        guard CellsType.allCases.count > indexPath.section else { return nil }
        return CellsType.allCases[indexPath.section]
    }
    
    func getWeatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData? {
        guard isDataLoaded else { return nil }
        guard weather.indices.contains(row) == true else { return nil }
        return WeatherCollection.DisplayData(town: weather[row].location.city, cellsCount: weather[row].weather.count)
    }
    
    func getWeatherCollectionCellDisplayData(collectionRow: Int, cellRow: Int) -> WeatherCell.DisplayData? {
        guard weather.indices.contains(collectionRow) == true else { return nil }
        guard weather[collectionRow].weather.indices.contains(cellRow) == true else { return nil }
        return WeatherCellDisplayDataFactory().displayData(weather: weather[collectionRow].weather[cellRow])
    }
    
    func getRouteCellHeight() -> CGFloat {
        return 0.0
    }
    
    func getHeaderText(for indexpath: IndexPath) -> String {
        switch indexpath.section {
        case 0:
            return L10n.route
        case 1:
            return L10n.weather
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

extension PlacesInfoPresenter: PlacesInfoInteractorOutput {
    func noWeatherForPlace(_ place: Place) {
        
    }
    
    func noPlacesInRoute() {
        didFetchAllWeatherData()
    }
    
    func didFetchAllWeatherData() {
        isDataLoaded = true
        sortWeather()
        view?.reloadData()
        hideLoadingView()
        if !locationsWithoutCoordinatesList.isEmpty {
            showNoCoordinatesAlert()
        }
    }
    
    func noCoordunates(for location: Location) {
        locationsWithoutCoordinatesList.append(location)
    }
    
    func didRecieveError(error: Error) {
        view?.showAlert(title: "Ошибка", message: "Возникла ошибка при загрузке данных")
    }
    
    func didRecieveWeatherData(_ weatherData: WeatherWithLocation) {
        weather.append(weatherData)
    }
}
