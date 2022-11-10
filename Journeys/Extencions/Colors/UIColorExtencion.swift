//
//  UIColorExtension.swift
//  Journeys
//
//  Created by Анастасия Ищенко on 06.11.2022.
//

import UIKit

extension UIColor {
    static let journeys = JourneysColors()
}

extension UIColor {
    static func UIColorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
