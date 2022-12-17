//
//  AddNewLocationPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import Foundation

// MARK: - AddNewLocationPresenter

final class AddNewLocationPresenter {
    
    // MARK: - Public Properties

    weak var view: AddNewLocationViewInput!
    weak var moduleOutput: AddNewLocationModuleOutput!
    private var place: Place?
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
    internal init(place: Place? = nil) {
        guard let place = place else { return }
        self.place = place
        selectedStartDate = place.arrive
        selectedEndDate = place.depart
    }

}

extension AddNewLocationPresenter: AddNewLocationModuleInput {
}

extension AddNewLocationPresenter: AddNewLocationViewOutput {
    
    func getCalendarCellData() -> CalendarCell.DisplayData {
        return CalendarCell.DisplayData(arrivalDate: place?.arrive, departureDate: place?.depart)
    }
    
    func getLocationCellData() -> AddNewLocationCell.DisplayData {
        guard let place = place else {
            return AddNewLocationCell.DisplayData(locationString: nil)
        }
        
        return AddNewLocationCell.DisplayData(locationString: place.location.country + ", " + place.location.city)
    }
    
    func didTapExitButton() {
        moduleOutput.addNewLoctionModuleWantsToClose()

    }
    
    func didTapDoneButton() {
        var startDate: Date?
        var finishDate: Date?
        if let dates = view.getCell(at: IndexPath(row: 1, section: 0))?.datesRange {
            let startDate = dates.first
            let finishDate = dates.last
        }
        // TODO: finish save
    }
    
    func didSelectCell(at indexpath: IndexPath) {
        return
    }
    
    func userSelectedDateRange(range: [Date]) {
        selectedStartDate = range.first
        selectedEndDate = range.last
    }
    
}
