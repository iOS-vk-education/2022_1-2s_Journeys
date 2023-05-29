//
//  PlaceViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import Foundation
import UIKit


// MARK: - Place ViewInput

protocol PlaceViewInput: AnyObject {
    func getCell(at indexPath: IndexPath) -> UITableViewCell?
    func showAlert(title: String, message: String)
    
    func setNotificationDateViewsVisibility(to value: Bool)
    func setDatePickerDefaultValue(_ date: Date)
    func datePickerValue() -> Date
    func addNotificationSwitchValue() -> Bool
    
    func setNotificationsSwitchIsEnabled(_ value: Bool)
    
    func reloadData()
}

// MARK: - Place ViewOutput

protocol PlaceViewOutput: AnyObject {
    func viewDidLoad()
    
    func didSelectCell(at indexpath: IndexPath)
    func didTapExitButton()
    func didTapDoneButton()
    
    func areNotificationDateViewsVisible() -> Bool?
    func notificationDate() -> Date?
    func switchValue() -> Bool?
    func setupDateViews(switchValue: Bool)
    func isNotificationsSwitchEnabled() -> Bool?
    
    func getPlaceCellData(for indexPath: IndexPath) -> LocationCell.DisplayData
    func getCalendarCellData() -> CalendarCell.DisplayData
    func userSelectedDateRange(range: [Date])
}
