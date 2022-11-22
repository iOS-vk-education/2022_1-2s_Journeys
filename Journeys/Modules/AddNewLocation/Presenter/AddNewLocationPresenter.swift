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
    var place: Place?
    
    internal init(place: Place? = nil) {
        self.place = place
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
        print("didTapDoneButton")
    }
    
//    func getDisplayData(for indexpath: IndexPath) -> AddNewLocationCell.DisplayData {
//        if indexpath.row == 0 {
//            return CalendarCell.DisplayData(arrivalDate: place?.arrive, DepartureDate: place?.depart)
//        }
//        return AddNewLocationCell.DisplayData(locationString: "location")
//    }
    
    func didSelectCell(at indexpath: IndexPath) {
        return
    }
    
}
