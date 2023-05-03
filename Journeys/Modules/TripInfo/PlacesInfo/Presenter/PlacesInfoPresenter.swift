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
    
    private var indexPathForCellWithOpenedPicker: IndexPath?
    
    init(interactor: PlacesInfoInteractorInput,
         router: PlacesInfoRouterInput,
         route: Route) {
        self.interactor = interactor
        self.router = router
        self.route = route
    }
    
    private func sortWeather(_ weather: [WeatherWithLocation], completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            var sortedWeather: [WeatherWithLocation] = []
            for place in self.route.places {
                for curWeather in weather {
                    if curWeather.isMatchToPlace(place) {
                        sortedWeather.append(curWeather)
                        break
                    }
                }
            }
            self.weather = sortedWeather
            completion()
        }
    }
    
    private func sortGeoData(_ placesWithGeoData: [PlaceWithGeoData],
                             completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            var sortedGeoData: [PlaceWithGeoData] = []
            for place in self.route.places {
                for placeWithGeoData in placesWithGeoData {
                    if placeWithGeoData.place.location == place.location {
                        sortedGeoData.append(placeWithGeoData)
                        break
                    }
                }
            }
            self.placesWithGeoData = sortedGeoData
            completion()
        }
    }
    
    private func sortCurrencyRate(_ locationsWithCurrencyRate: [LocationsWithCurrencyRate],
                                  completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            var sortedCurrencyRate: [LocationsWithCurrencyRate] = []
            for place in self.route.places {
                for currencyRate in locationsWithCurrencyRate {
                    if currencyRate.locations.first == place.location {
                        sortedCurrencyRate.append(currencyRate)
                        break
                    }
                }
            }
            self.locationsWithCurrencyRate = sortedCurrencyRate
            completion()
        }
    }
    
    private func showLoadingView() {
        view?.showLoadingView()
    }
    private func hideLoadingView() {
        view?.hideLoadingView()
    }
    
    private func reloadView() {
        view?.reloadData()
        hideLoadingView()
        view?.endRefresh()
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
        let locationsWithoutCoordinatesString: String = locationsWithoutCoordinatesList
            .compactMap( { $0.toString() } ).joined(separator: ", ")
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
    
    private func getCurrencies(for currentCurrencyCode: String) {
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
        interactor.currencyRate(for: countryCodesDict,
                                currentCurrencyCode: currentCurrencyCode,
                                amount: 1)
    }
}

extension PlacesInfoPresenter: PlacesInfoModuleInput {
}

extension PlacesInfoPresenter: PlacesInfoViewOutput {
    func viewDidLoad() {
        showLoadingView()
        interactor.geoData(for: route)
    }
    
    func refreshView() {
        weather = []
        locationsWithoutCoordinatesList = []
        placesWithGeoData = []
        locationsWithCurrencyRate = []
        
        view?.reloadData()
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
        return CurrencyCellDisplayDataFactory().displayData(locationsWithCurrencyRate: locationsWithCurrencyRate[indexPath.row])
    }
    
    func eventCellDisplayData(for indexPath: IndexPath) -> EventMapCell.DisplayData? {
        guard placesWithGeoData.count > indexPath.row else { return nil }
        let coordinates = placesWithGeoData[indexPath.row].coordinates
        return EventMapCell.DisplayData(title: placesWithGeoData[indexPath.row].place.location.city,
                                        latitude: coordinates.latitude,
                                        longitude: coordinates.longitude)
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

// MARK: Work with picker view

extension PlacesInfoPresenter {
    func pickerViewTitle(for row: Int) -> String? {
        guard Locale.commonISOCurrencyCodes.count > row else { return nil }
        return Locale.commonISOCurrencyCodes[row]
    }
    
    func pickerViewRowsCount() -> Int {
        Locale.commonISOCurrencyCodes.count
    }
    
    func didSelectNewCurrency(at row: Int) {
        guard let cellIndexPath = indexPathForCellWithOpenedPicker,
              Locale.commonISOCurrencyCodes.count > row,
              locationsWithCurrencyRate.count > cellIndexPath.row else { return }
        let newCurrency = locationsWithCurrencyRate[cellIndexPath.row].currencyRate.newCurrency
        interactor.updateCurrencyRate(from: Locale.commonISOCurrencyCodes[row],
                                      to: newCurrency,
                                      amount: 1) { [weak self] currencyRate in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.locationsWithCurrencyRate[cellIndexPath.row].currencyRate = currencyRate
                var localCurrencyAmountString: String?
                
                if let currentCurrencyAmount = self.view?
                    .currencyAmountString(at: cellIndexPath, viewType: .currentCurrency)?
                    .replacingOccurrences(of: ",", with: ".").toFloat {
                    
                    let localCurrencyAmount = currentCurrencyAmount * self.locationsWithCurrencyRate[cellIndexPath.row].currencyRate.newAmount
                    
                    localCurrencyAmountString = String(localCurrencyAmount)
                        .replacingOccurrences(of: ".", with: ",")
                }
                
                self.view?.updateCurrencyCell(at: cellIndexPath,
                                              displayData: CurrencyCellDisplayDataFactory().displayData(locationsWithCurrencyRate: self.locationsWithCurrencyRate[cellIndexPath.row]),
                                              localCurrencyAmount: localCurrencyAmountString)
            }
        }
    }
}

extension PlacesInfoPresenter: PlacesInfoInteractorOutput {
    func didFetchGeoData(_ placesWithGeoData: [PlaceWithGeoData]) {
        sortGeoData(placesWithGeoData) { [weak self] in
            guard let self else { return }
            if placesWithGeoData.count > 0 {
                self.reloadView()
                self.interactor.weatherData(placesWithGeoData: placesWithGeoData)
                let locale = Locale.current
                guard let currentCurrencyCode = locale.currencyCode else { return }
                self.getCurrencies(for: currentCurrencyCode)
            } else {
                self.reloadView()
            }
        }
    }
    
    func didFetchCurrencyRates(_ locationsWithCurrencyRate: [LocationsWithCurrencyRate]) {
        sortCurrencyRate(locationsWithCurrencyRate) { [weak self] in
            guard let self else { return }
            self.reloadView()
        }
    }
    
    func noWeatherForPlace(_ place: Place) {
        
    }
    
    func noPlacesInRoute() {
        self.reloadView()
        if !locationsWithoutCoordinatesList.isEmpty {
            showNoCoordinatesAlert()
        }
    }
    
    func didFetchAllWeatherData(_ weather: [WeatherWithLocation]) {
        sortWeather(weather) { [weak self] in
            guard let self else { return }
            self.reloadView()
            if !self.locationsWithoutCoordinatesList.isEmpty {
                self.showNoCoordinatesAlert()
            }
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
    func didTapCurrencyNameButton(touch: UITapGestureRecognizer,
                                  at indexPath: IndexPath,
                                  currentCurrency: String,
                                  viewType: CurrencyView.ViewType) {
        if viewType == .currentCurrency {
            indexPathForCellWithOpenedPicker = indexPath
            guard let index = Locale.commonISOCurrencyCodes
                .firstIndex(where: { $0 == currentCurrency }) else {
                view?.showPickerView(touch: touch,
                                     with: 0)
                return
            }
            view?.showPickerView(touch: touch,
                                 with: index)
        }
    }
    
    func didFinishEditingTextField(at indexPath: IndexPath,
                                   text: String,
                                   viewType: CurrencyView.ViewType) {
        guard locationsWithCurrencyRate.count > indexPath.row else { return }
        let amount = text.replacingOccurrences(of: ",",
                                              with: ".").toFloat
        let course = locationsWithCurrencyRate[indexPath.row].currencyRate
        let result: Float?
        
        var viewToChangeValueType: CurrencyView.ViewType
        switch viewType {
        case .currentCurrency:
            viewToChangeValueType = .localCurrency
            result = course.newAmount / course.oldAmount * amount
        case .localCurrency:
            viewToChangeValueType = .currentCurrency
            result = course.oldAmount / course.newAmount * amount
        default: break
        }
        guard let result else { return }
        view?.changeCurrencyTextField(at: indexPath,
                                      viewType: viewToChangeValueType,
                                      to: String(format: "%.2f", result).replacingOccurrences(of: ".",
                                                                                              with: ","))
    }
}
