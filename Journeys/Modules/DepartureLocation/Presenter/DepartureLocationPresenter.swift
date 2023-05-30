//
//  DepartureLocationPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import Foundation

// MARK: - DepartureLocationPresenter


final class DepartureLocationPresenter {
    
    // MARK: - Public Properties

    weak var view: DepartureLocationViewInput!
    weak var moduleOutput: DepartureLocationModuleOutput!
    
    weak var routeModule: RouteModuleInput?
    
    private var departureLocation: Location?
    
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
    internal init(departureLocation: Location? = nil, routeModuleInput: RouteModuleInput) {
        self.departureLocation = departureLocation
        self.routeModule = routeModuleInput
    }

    private func showAlert(error: Errors) {
        guard let alertShowingVC = view as? AlertShowingViewController else { return }
        askToShowErrorAlert(error, alertShowingVC: alertShowingVC)
    }
}

extension DepartureLocationPresenter: DepartureLocationModuleInput {
}

extension DepartureLocationPresenter: DepartureLocationViewOutput {
    
    func getDepartureLocationCellData(for indexPath: IndexPath) -> LocationCell.DisplayData {
        if indexPath.row == 0 {
            if let departureLocation = departureLocation {
                return LocationCell.DisplayData(locationString: departureLocation.country, cellType: .country)
            } else {
                return LocationCell.DisplayData(locationString: nil, cellType: .country)
            }
        } else {
            if let departureLocation = departureLocation {
                return LocationCell.DisplayData(locationString: departureLocation.city, cellType: .city)
            } else {
                return LocationCell.DisplayData(locationString: nil, cellType: .city)
            }
        }
    }
    
    func didTapExitButton() {
        moduleOutput.departureLocationModuleWantsToClose()

    }
    
    func didTapDoneButton() {
        guard let countryCell = view.getCell(at: IndexPath(row: 0, section: 0)) as? LocationCell,
              let cityCell = view.getCell(at: IndexPath(row: 1, section: 0)) as? LocationCell else {
            showAlert(error: .saveDataError)
            return
        }
        guard let country = countryCell.getTextFieldValue(),
              let city = cityCell.getTextFieldValue() else {
            showAlert(error: .custom(title: nil, message: L10n.fillTheCountryAndTownFields))
            return
        }
        
        departureLocation = Location(country: country,
                                     city: city)
        // TODO: finish save
        guard let departureLocation = departureLocation else {
            showAlert(error: .obtainDataError)
            return
        }
        routeModule?.updateRouteDepartureLocation(location: departureLocation)
        moduleOutput.departureLocationModuleWantsToClose()
    }
    
    func userSelectedDateRange(range: [Date]) {
        selectedStartDate = range.first
        selectedEndDate = range.last
    }
}

extension DepartureLocationPresenter: AskToShowAlertProtocol {
}
