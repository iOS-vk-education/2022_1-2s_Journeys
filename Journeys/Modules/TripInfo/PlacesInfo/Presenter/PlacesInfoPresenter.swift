//
//  PlacesInfoPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit

// MARK: - PlacesIngoPresenter

final class PlacesInfoPresenter {
    enum CellType: Int, CaseIterable {
        case route
        case weather
        case currency
        case events
    }
    
    // MARK: - Public Properties

    weak var view: PlacesInfoViewInput?
    private let interactor: PlacesInfoInteractorInput
    private let router: PlacesInfoRouterInput
    weak var moduleOutput: PlacesInfoModuleOutput?
    private var route: Route
    private var weather: [WeatherWithLocation] = []
    
    private var locationsWithoutCoordinatesList: [Location] = []
    private var placesWithGeoData: [PlaceWithGeoData] = []
    private var locationsWithCurrencyRate: [LocationsWithCurrencyRate] = []
    
    
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
    
    private func getCurrencies() {
        guard let currentCurrencyCode = Locale.currency["US"]?.code else { return }
        
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
        interactor.currencyRate(for: countryCodesDict, currentCurrencyCode: currentCurrencyCode, amount: 1)
    }
}

extension PlacesInfoPresenter: PlacesInfoModuleInput {
}

extension PlacesInfoPresenter: PlacesInfoViewOutput {
    func viewDidLoad() {
        showLoadingView()
        interactor.geoData(for: route)
    }
    
    func didTapExitButton() {
        moduleOutput?.placesModuleWantsToClose()
    }
}

// MARK: work with MainCollectionView

extension PlacesInfoPresenter {
    func headerText(for indexPath: IndexPath) -> String {
        guard CellType.allCases.count > indexPath.section else { return "" }
        let section = CellType.allCases[indexPath.section]
        switch section {
        case .route:
            return L10n.route
        case .weather:
            return L10n.weather
        case .currency:
            return L10n.currency
        case .events:
            return L10n.events
        default:
            return ""
        }
    }
    
    func sectionsCount() -> Int {
        CellType.allCases.count
    }
    
    func mainCollectionCellsCount(for section: Int) -> Int {
        guard CellType.allCases.count > section else { return 0 }
        if CellType.allCases[section] == .route { return 1 }
        let section = CellType.allCases[section]
        switch section {
        case .route: return 1
        case .weather:
            return weather.count == 0 ? 1 : weather.count
        case .currency:
            return locationsWithCurrencyRate.count == 0 ? 1 : locationsWithCurrencyRate.count
        case .events:
            return placesWithGeoData.count == 0 ? 1 : placesWithGeoData.count
        default: return 0
        }
    }
    
    func mainCollectionCellType(for indexPath: IndexPath) -> CellType? {
        guard CellType.allCases.count > indexPath.section else { return nil }
        if CellType.allCases[indexPath.section] == .route { return .route }
        return CellType.allCases[indexPath.section]
    }
    
    func routeCellDisplayData() -> ShortRouteCell.DisplayData? {
        let arrow: String = " → "
        var routeString: String = route.departureLocation.city + arrow
        routeString += route.places.compactMap( { $0.location.city } )
            .joined(separator: arrow)
        return ShortRouteCell.DisplayData(route: routeString)
    }
    
    func weatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData? {
        guard weather.count > row  else { return nil }
        return WeatherCollection.DisplayData(town: weather[row].location.city, cellsCount: weather[row].weather.count)
    }
    
    func currencyCellDisplayData(for indexPath: IndexPath) -> CurrencyCell.DisplayData? {
        guard locationsWithCurrencyRate.count > indexPath.row else { return nil }
        let title = locationsWithCurrencyRate[indexPath.row]
            .locations.compactMap( { $0.city } ).joined(separator: ", ")
        let currencyRate = locationsWithCurrencyRate[indexPath.row].currencyRate
        return CurrencyCell.DisplayData(title: title,
                                        currentCurrencyAmount: String(currencyRate.oldAmount)
            .replacingOccurrences(of: ".", with: ","),
                                        localCurrencyAmount: String(currencyRate.newAmount)
            .replacingOccurrences(of: ".", with: ","),
                                        currentCurrencyName: currencyRate.oldCurrency,
                                        localCurrencyName: currencyRate.newCurrency)
    }
    
    func eventCellDisplayData(for indexPath: IndexPath) -> EventMapCell.DisplayData? {
        guard placesWithGeoData.count > indexPath.row else { return nil }
        let coordinates = placesWithGeoData[indexPath.row].coordinates
        return EventMapCell.DisplayData(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard CellType.allCases.count > indexPath.section else { return }
        guard CellType.allCases[indexPath.section] == .events else { return }
        guard placesWithGeoData.count > indexPath.row else { return }
        moduleOutput?.openEventsModule(with: placesWithGeoData[indexPath.row].coordinates)
    }
}

// MARK: Work with weatherCollection

extension PlacesInfoPresenter {
    func weatherCollectionCellsCount(for indexPath: IndexPath) -> Int {
        guard weather.indices.contains(indexPath.row) == true else { return 0 }
        return weather[indexPath.row].weather.count
    }
    
    func weatherCollectionCellDisplayData(collectionRow: Int, cellRow: Int) -> WeatherCell.DisplayData? {
        guard weather.indices.contains(collectionRow) == true else { return nil }
        guard weather[collectionRow].weather.indices.contains(cellRow) == true else { return nil }
        return WeatherCellDisplayDataFactory().displayData(weather: weather[collectionRow].weather[cellRow])
    }
}

extension PlacesInfoPresenter: PlacesInfoInteractorOutput {
    
    func didFetchCurrencyRates(_ locationsWithCurrencyRate: [LocationsWithCurrencyRate]) {
        self.locationsWithCurrencyRate = locationsWithCurrencyRate
        view?.reloadData()
        hideLoadingView()
    }
    
    func didFetchGeoData(_ placesWithGeoData: [PlaceWithGeoData]) {
        self.placesWithGeoData = placesWithGeoData
        interactor.weatherData(placesWithGeoData: placesWithGeoData)
        getCurrencies()
        view?.reloadData()
    }
    
    func noWeatherForPlace(_ place: Place) {
        
    }
    
    func noPlacesInRoute() {
        view?.reloadData()
        hideLoadingView()
        if !locationsWithoutCoordinatesList.isEmpty {
            showNoCoordinatesAlert()
        }
    }
    
    func didFetchAllWeatherData(_ weather: [WeatherWithLocation]) {
        self.weather = weather
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
}

extension PlacesInfoPresenter: CurrencyCellDelegate {
    func didFinishEditingTextField(at indexPath: IndexPath,
                                   text: String,
                                   viewType: CurrencyView.ViewType) {
        guard locationsWithCurrencyRate.count > indexPath.row else { return }
        let amount = text.replacingOccurrences(of: ",",
                                              with: ".").toFloat
        let course = locationsWithCurrencyRate[indexPath.row].currencyRate
        let result: Float?
        switch viewType {
        case .currentCurrency: result = course.newAmount / course.oldAmount * amount
        case .localCurrency: result = course.oldAmount / course.newAmount * amount
        default: break
        }
        guard let result else { return }
        view?.changeCurrencyTextField(at: indexPath,
                                      viewType: viewType,
                                      to: String(format: "%.2f", result).replacingOccurrences(of: ".",
                                                                                              with: ","))
    }
}
