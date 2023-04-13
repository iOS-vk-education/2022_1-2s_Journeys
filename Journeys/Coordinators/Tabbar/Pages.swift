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
    case account

    var pageTitle: String {
        switch self {
        case .journeys:
            return L10n.journeys
        case .events:
            return L10n.events
        case .account:
            return L10n.account
        }
    }

    var numberOfPage: Int {
        switch self {
        case .journeys:
            return 0
        case .events:
            return 1
        case .account:
            return 2
        }
    }

    var pageIconName: String {
        switch self {
        case .journeys:
            return "globe.europe.africa.fill"
        case .events:
            return "mappin.and.ellipse"
        case .account:
            return "person.fill"
        }
    }
}
