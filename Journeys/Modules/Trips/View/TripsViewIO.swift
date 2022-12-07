//
//  TripsViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation

// MARK: - Trips ViewInput

protocol TripsViewInput: AnyObject {
}

// MARK: - Trips ViewOutput

protocol TripsViewOutput: AnyObject {
    func didSelectCell(at indexpath: IndexPath)
    
    func getTripCellsCount() -> Int
    func getCellData(for id: Int) -> TripCell.DisplayData?
}
