//
//  PlaceholderDisplayData.swift
//  Journeys
//
//  Created by Сергей Адольевич on 27.12.2022.
//

import Foundation

protocol PlaceholderDisplayDataFactoryProtocol {
    func displayData() -> TripsPlaceholderViewController.DisplayData
}

// MARK: - PlaceholderDisplayDataFactory

final class PlaceholderDisplayDataFactory: PlaceholderDisplayDataFactoryProtocol {
    func displayData() -> TripsPlaceholderViewController.DisplayData {
        TripsPlaceholderViewController.DisplayData(title: "Пока что маршрутов нет",
                                              imageName: "TripsPlaceholder")
    }
}
