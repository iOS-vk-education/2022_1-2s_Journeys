//
//  RouteCellDisplayDataFactory.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

protocol RouteCellDisplayDataFactoryProtocol: AnyObject {
    func displayData(cellType: RouteCell.CellType) -> RouteCell.DisplayData
}

final class RouteCellDisplayDataFactory: RouteCellDisplayDataFactoryProtocol {
    let commaAndSpace = ", "
    
    func displayData(cellType: RouteCell.CellType) -> RouteCell.DisplayData {
        let textfield = UITextField()
        
        var placeholder: String
        var color: UIColor
        var text: String? = nil
        var iconName: String
        
        switch cellType {
        case let .arrivalTown(location):
            if let location = location {
                color = UIColor(asset: Asset.Colors.Text.mainTextColor) ?? .black
                text = location.country + commaAndSpace + location.city
                iconName = "mappin.and.ellipse"
            } else {
                text = L10n.arrivalTown
                color = UIColor(asset: Asset.Colors.Placeholder.placeholderColor) ?? .black
                iconName = "magnifyingglass"
            }
        case let .departureTown(location):
            if let location = location {
                color = UIColor(asset: Asset.Colors.Text.mainTextColor) ?? .black
                text = location.country + commaAndSpace + location.city
                iconName = "mappin.and.ellipse"
            } else {
                text = L10n.departureTown
                color = UIColor(asset: Asset.Colors.Placeholder.placeholderColor) ?? .black
                iconName = "magnifyingglass"
            }
        case .newLocation:
            text = L10n.addTown
            color = UIColor(asset: Asset.Colors.Placeholder.placeholderColor) ?? .black
            iconName = "plus"
        }
        
        let icon = UIImage(systemName: iconName) ?? UIImage()
        
        textfield.backgroundColor = .red
        return RouteCell.DisplayData(icon: icon, color: color, text: text)
    }
    
}
