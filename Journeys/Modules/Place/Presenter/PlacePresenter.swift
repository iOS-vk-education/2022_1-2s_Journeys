//
//  PlacePresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import Foundation

// MARK: - PlacePresenter


final class PlacePresenter {
    
    // MARK: - Public Properties
    
    weak var view: PlaceViewInput?
    weak var moduleOutput: PlaceModuleOutput?
    var model: PlaceModelInput?
    
    weak var routeModule: RouteModuleInput?
    
    private var place: Place?
    private let placeIndex: Int
    
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
    internal init(place: Place? = nil, placeIndex: Int, routeModuleInput: RouteModuleInput) {
        self.place = place
        self.placeIndex = placeIndex
        selectedStartDate = place?.arrive
        selectedEndDate = place?.depart
        self.routeModule = routeModuleInput
    }
    
}

extension PlacePresenter: PlaceModuleInput {
}

extension PlacePresenter: PlaceViewOutput {
    func areNotificationDateViewsVisible() -> Bool? {
        place?.allowNotification
    }
    
    func switchValue() -> Bool? {
        place?.allowNotification
    }
    
    func setupDateViews(switchValue: Bool) {
        if switchValue, let date = notificationDate() {
            view?.setDatePickerDefaultValue(date)
        }
        view?.setNotificationDateViewsVisibility(to: switchValue)
    }
    
    func notificationDate() -> Date? {
        if let notification = place?.notification {
            return notification.date
        } else if let arriveDate = place?.arrive,
                  let date = Calendar.current.date(byAdding: .day, value: -1, to: arriveDate),
                  let newDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date) {
            return newDate
        }
        return nil
    }
    
    func getCalendarCellData() -> CalendarCell.DisplayData {
        return CalendarCell.DisplayData(arrivalDate: place?.arrive, departureDate: place?.depart)
    }
    
    func getPlaceCellData(for indexPath: IndexPath) -> LocationCell.DisplayData {
        if indexPath.row == 0 {
            if let place = place {
                return LocationCell.DisplayData(locationString: place.location.country, cellType: .country)
            } else {
                return LocationCell.DisplayData(locationString: nil, cellType: .country)
            }
        } else {
            if let place = place {
                return LocationCell.DisplayData(locationString: place.location.city, cellType: .city)
            } else {
                return LocationCell.DisplayData(locationString: nil, cellType: .city)
            }
        }
    }
    
    func didTapExitButton() {
        moduleOutput?.placeModuleWantsToClose()
        
    }
    
    func didTapDoneButton() {
        guard let view,
              let countryCell = view.getCell(at: IndexPath(row: 0, section: 0)) as? LocationCell,
              let cityCell = view.getCell(at: IndexPath(row: 1, section: 0)) as? LocationCell else {
            assertionFailure("Error while getting Place Data")
            return
        }
        guard let country = countryCell.getTextFieldValue(),
              let city = cityCell.getTextFieldValue() else {
            view.showAlert(title: L10n.blanckFields, message: L10n.fillTheCountryAndTownFields)
            return
        }
        
        guard let calendarCell = view.getCell(at: IndexPath(row: 0, section: 1)) as? CalendarCell else {
            assertionFailure("Error while getting calendat Data")
            return
        }
        let dates = calendarCell.getDates()
        guard let arrivaleDate = dates?.first,
              let departDate = dates?.last else {
            view.showAlert(title: L10n.blanckFields, message: L10n.selectDates)
            return
        }
        
        place = Place(location: Location(country: country,
                                         city: city),
                      arrive: arrivaleDate,
                      depart: departDate,
                      allowNotification: view.addNotificationSwitchValue())
        guard var place = place else {
            view.showAlert(title: "Ошибка", message: "Ошибка при сохранении данных")
            return
        }
        
        if view.addNotificationSwitchValue() {
            let notification = PlaceNotification(id: nil,
                                                 date: view.datePickerValue(),
                                                 placeForContent: place)
            place.notification = notification
            self.place?.notification = notification
        }
        
        routeModule?.updateRoutePlaces(place: place, placeIndex: placeIndex)
        moduleOutput?.placeModuleWantsToClose()
    }
    
    func didSelectCell(at indexpath: IndexPath) {
        return
    }
    
    func userSelectedDateRange(range: [Date]) {
        selectedStartDate = range.first
        selectedEndDate = range.last
    }
}

extension PlacePresenter: PlaceModelOutput {
    
}
