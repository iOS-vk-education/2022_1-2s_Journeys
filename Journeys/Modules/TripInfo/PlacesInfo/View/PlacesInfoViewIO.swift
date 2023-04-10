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

    func sectionsCount() -> Int
    func mainCollectionCellsCount(for section: Int) -> Int
    func getWeatherCollectionCellsCount(for collectionIndexPath: IndexPath) -> Int
    func mainCollectionCellType(for indexPath: IndexPath) -> PlacesInfoPresenter.CellsType?
    
    func getRoutelData() -> ShortRouteCell.DisplayData?
    func getWeatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData?
    func getWeatherCollectionCellDisplayData(collectionRow: Int, cellRow: Int) -> WeatherCell.DisplayData?

    func getHeaderText(for indexPath: IndexPath) -> String

    
    func didTapExitButton()
}
