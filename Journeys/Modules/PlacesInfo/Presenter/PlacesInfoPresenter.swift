//
//  PlacesIngoPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit

// MARK: - PlacesIngoPresenter

final class PlacesInfoPresenter {
    // MARK: - Public Properties

    weak var view: PlacesInfoViewInput!

}

extension PlacesInfoPresenter: PlacesInfoModuleInput {
}

extension PlacesInfoPresenter: PlacesInfoViewOutput {
    func getWeatherCollectionDisplayData() -> WeatherCollection.DisplayData {
        WeatherCollection.DisplayData(town: "Курск")
    }
    
    func getWeatherCollectionCellsCount() -> Int {
        5
    }
    
    func getWeatherCollectionCellDisplayData() -> WeatherCell.DisplayData {
        WeatherCell.DisplayData(icon: UIImage(systemName: "sun.max.fill") ?? UIImage(), date: "21 пт", temperature: "+21")
    }
    
    func getHeaderText(for indexpath: IndexPath) -> String {
        switch indexpath.section {
        case 0:
            return "Маршрут"
        case 1:
            return "Погода"
        default:
            return ""
        }
    }
    
    func getRoutelData() -> RouteCell.DisplayData {
        let arrow: String = " → "
        return RouteCell.DisplayData(route: "Москва \(arrow) Курск \(arrow) Анапа")
    }
    
    func getCellsCount(for section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
    
}
