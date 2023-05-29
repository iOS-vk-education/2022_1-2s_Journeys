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
}

// MARK: - DepartureLocation ViewOutput

protocol DepartureLocationViewOutput: AnyObject {
    func didTapExitButton()
    func didTapDoneButton()
    
    func getDepartureLocationCellData(for indexPath: IndexPath) -> LocationCell.DisplayData
    func userSelectedDateRange(range: [Date])
}
