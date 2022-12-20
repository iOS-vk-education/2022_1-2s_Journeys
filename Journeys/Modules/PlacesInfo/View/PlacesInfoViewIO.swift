//
//  PlacesIngoViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//
import Foundation

// MARK: - PlacesIngo ViewInput

protocol PlacesInfoViewInput: AnyObject {
}

// MARK: - PlacesIngo ViewOutput

protocol PlacesInfoViewOutput: AnyObject {
    func getHeaderText(for indexpath: IndexPath) -> String
    func getRoutelData() -> RouteCell.DisplayData
    func getCellsCount(for section: Int) -> Int
    
    func getWeatherCollectionDisplayData() -> WeatherCollection.DisplayData
    func getWeatherCollectionCellsCount() -> Int
    func getWeatherCollectionCellDisplayData() -> WeatherCell.DisplayData
}
