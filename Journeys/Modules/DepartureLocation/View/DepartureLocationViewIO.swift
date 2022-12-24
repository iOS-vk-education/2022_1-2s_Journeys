//
//  DepartureLocationViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

import Foundation
import UIKit


// MARK: - DepartureLocation ViewInput

protocol DepartureLocationViewInput: AnyObject {
    func getCell(at indexPath: IndexPath) -> UITableViewCell?
    func showAlert(title: String, message: String)
}

// MARK: - DepartureLocation ViewOutput

protocol DepartureLocationViewOutput: AnyObject {
    func didSelectCell(at indexpath: IndexPath)
    func didTapExitButton()
    func didTapDoneButton()
    
    func getDepartureLocationCellData(for indexPath: IndexPath) -> LocationCell.DisplayData
    func userSelectedDateRange(range: [Date])
}
