//
//  PlacesIngoViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//
import Foundation

// MARK: - PlacesIngo ViewInput

protocol PlacesInfoViewInput: AnyObject {
    func reloadData()
}

// MARK: - PlacesIngo ViewOutput

protocol PlacesInfoViewOutput: AnyObject {
    func viewDidLoad()
    
    func getHeaderText(for indexpath: IndexPath) -> String
    func getRoutelData() -> ShortRouteCell.DisplayData?
    func getMainCollectionCellsCount(for section: Int) -> Int
    
    func getWeatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData?
    func getWeatherCollectionCellsCount(for row: Int) -> Int
    func getWeatherCollectionCellDisplayData(collectionRow: Int, cellRow: Int) -> WeatherCell.DisplayData?
    
    func didTapExitButton()
}
