//
//  PlacesIngoViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//
import Foundation
import UIKit

// MARK: - PlacesIngo ViewInput

protocol PlacesInfoViewInput: AnyObject {
    func reloadData()
    func showAlert(title: String, message: String)
    func showLoadingView()
    func hideLoadingView()
}

// MARK: - PlacesIngo ViewOutput

protocol PlacesInfoViewOutput: AnyObject {
    func viewDidLoad()

    func isEmptyCellNeed() -> Bool
    func getEmptyCellData() -> String
    func getHeaderText(for indexpath: IndexPath) -> String
    func getRouteCellHeight() -> CGFloat
    func getRoutelData() -> ShortRouteCell.DisplayData?
    func getMainCollectionCellsCount(for section: Int) -> Int
    
    func getWeatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData?
    func getWeatherCollectionCellsCount(for collectionIndexPath: IndexPath) -> Int
    func getWeatherCollectionCellDisplayData(collectionRow: Int, cellRow: Int) -> WeatherCell.DisplayData?
    
    func didTapExitButton()
}
