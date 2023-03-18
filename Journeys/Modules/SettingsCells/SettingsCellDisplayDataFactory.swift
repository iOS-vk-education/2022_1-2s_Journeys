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
    
    private let notificationsManager: NotificationsManagerProtocol = NotificationsManager.shared
    
    // MARK: Public
    
    func settingsDisplayData(for type: SettingsCell.CellType.Settings,
                             switchValue: Bool? = nil) -> SettingsCell.DisplayData {
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
                                            type: .usual)
        }
    }
    func accountDisplayData(for type: SettingsCell.CellType.Account,
                             switchValue: Bool? = nil) -> SettingsCell.DisplayData {
        
        switch type {
        case .accountInfo:
            return SettingsCell.DisplayData(title: L10n.accountInfo,
                                            type: .chevronType)
        case .stuffLists:
            return SettingsCell.DisplayData(title: L10n.stuffLists,
                                            type: .usual)
        case .settings:
            return SettingsCell.DisplayData(title: L10n.settings,
                                            type: .chevronType)
        default:
            return SettingsCell.DisplayData(title: "",
                                            type: .usual)
        }
    }
}

