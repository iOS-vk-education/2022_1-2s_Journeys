//
//  NewRouteCellDisplayDataFactory.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

protocol NewRouteCellDisplayDataFactoryProtocol: AnyObject {
    func displayData(cellType: NewRouteCellType) -> NewRouteCellDisplayData
}

final class NewRouteCellDisplayDataFactory: NewRouteCellDisplayDataFactoryProtocol {
    let commaAndSpace = ", "
    
    func displayData(cellType: NewRouteCellType) -> NewRouteCellDisplayData {
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
            text = L10n.newRoute
            color = UIColor(asset: Asset.Colors.Placeholder.placeholderColor) ?? .black
            iconName = "plus"
        }
        
        let icon = UIImage(systemName: iconName) ?? UIImage()
        
        textfield.backgroundColor = .red
        return NewRouteCellDisplayData(icon: icon, color: color, text: text)
    }
    
}
