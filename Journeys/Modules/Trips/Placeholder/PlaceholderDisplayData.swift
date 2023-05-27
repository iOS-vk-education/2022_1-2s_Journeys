//
//  PlaceholderDisplayData.swift
//  Journeys
//
//  Created by Сергей Адольевич on 27.12.2022.
//

import Foundation

protocol PlaceholderDisplayDataFactoryProtocol {
    func displayData() -> PlaceholderViewController.DisplayData
}

// MARK: - PlaceholderDisplayDataFactory

final class PlaceholderDisplayDataFactory: PlaceholderDisplayDataFactoryProtocol {
    func displayData() -> PlaceholderViewController.DisplayData {
        PlaceholderViewController.DisplayData(title: "Пока что маршрутов нет",
                                              imageName: "TripsPlaceholder")
    }
}
