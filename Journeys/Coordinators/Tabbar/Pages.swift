//
//  Pages.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.12.2022.
//

import Foundation
import UIKit

enum TabBarPage: CaseIterable {
    case journeys
    case events
    case settings

    var pageTitle: String {
        switch self {
        case .journeys:
            return L10n.journeys
        case .events:
            return L10n.events
        case .settings:
            return L10n.settings
        }
    }

    var numberOfPage: Int {
        switch self {
        case .journeys:
            return 0
        case .events:
            return 1
        case .settings:
            return 2
        }
    }

    var pageIconName: String {
        switch self {
        case .journeys:
            return "globe.europe.africa.fill"
        case .events:
            return "mappin.and.ellipse"
        case .settings:
            return "gearshape"
        }
    }
}
