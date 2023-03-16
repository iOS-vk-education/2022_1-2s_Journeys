//
//  SettingsDisplayDataFactory.swift
//  DrPillman
//
//  Created by Анастасия Ищенко on 10.03.2023.
//

import Foundation

// MARK: - SettingsDisplayDataFactory

final class SettingsDisplayDataFactory {
    // MARK: Private

    private let notificationsManager: NotificationsManagerProtocol

    // MARK: Lifecycle

    init(notificationsManager: NotificationsManagerProtocol) {
        self.notificationsManager = notificationsManager
    }

    // MARK: Public

    func displayData(for type: SettingsCell.CellType, switchValue: Bool? = nil) -> SettingsCell.DisplayData {
        switch type {
        case .notifications:
            return SettingsCell.DisplayData(title: L10n.notifications,
                                            type: .switchType(switchValue ?? false))
        case .style:
            return SettingsCell.DisplayData(title: L10n.style,
                                            type: .chevronType)
        case .language:
            let language = Language.selectedLanguage.rawValue
            
            return SettingsCell.DisplayData(title: L10n.language,
                                            subtitle: language,
                                            type: .chevronType)
        case .help:
            return SettingsCell.DisplayData(title: L10n.help,
                                            type: .chevronType)
        case .rate:
            return SettingsCell.DisplayData(title: L10n.rateApp,
                                            type: .chevronType)
        default:
            return SettingsCell.DisplayData(title: "",
                                            type: .chevronType)
        }
    }
}
