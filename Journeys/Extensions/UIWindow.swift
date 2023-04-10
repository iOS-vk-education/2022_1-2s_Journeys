//
//  UIWindow.swift
//  Journeys
//
//  Created by Сергей Адольевич on 16.03.2023.
//

import Foundation
import UIKit

extension UIWindow {
    // Устанавливаем текущую тему для окна
    // Необходимо вызывать перед показом окна
    func initTheme() {
        overrideUserInterfaceStyle = Theme.current.userInterfaceStyle
    }
}
