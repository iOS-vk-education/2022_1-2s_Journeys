//
//  ThemeWindow.swift
//  DrPillman
//
//  Created by Анастасия Ищенко on 10.03.2023.
//

import Foundation
import UIKit

final class ThemeWindow: UIWindow {
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Если текущая тема системная и поменяли оформление в iOS, опять меняем тему на системную.
        // Например: Пользователь поменял светлое оформление на темное.
        if Theme.current == .system {
            Theme.system.setActive()
        }
    }
}
