//
//  AddNewLocationViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import Foundation


// MARK: - AddNewLocation ViewInput

protocol AddNewLocationViewInput: AnyObject {
}

// MARK: - AddNewLocation ViewOutput

protocol AddNewLocationViewOutput: AnyObject {
//    func getDisplayData(for indexpath: IndexPath) -> AddNewLocationCell.DisplayData
    func didSelectCell(at indexpath: IndexPath)
    func didTapExitButton()
    func didTapDoneButton()
    
    func getLocationCellData() -> AddNewLocationCell.DisplayData
    func getCalendarCellData() -> CalendarCell.DisplayData
}
