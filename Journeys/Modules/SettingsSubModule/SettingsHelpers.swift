//
//  SettingsViewType.swift
//  Settings
//
//  Created by Анастасия Ищенко on 10.03.2023.
//

import Foundation

// MARK: - SettingsViewType

enum SettingsViewType: Int, CaseIterable, Identifiable {
    case style
    case language
    case help
    case rate
    case info

    var id: Int {
        rawValue
    }

    var localized: String {
        switch self {
        case .style:
            return L10n.style
        case .language:
            return L10n.language
        case .help:
            return L10n.help
        case .rate:
            return L10n.rateApp
        case .info:
            return L10n.information
        }
    }
}

// MARK: - Language

enum Language: String, CaseIterable, Identifiable {
    case english = "English"
    case russian = "Русский"

    static var selectedLanguage: Language {
        let language = LocalizationSystem.sharedInstance.getLanguage()
        if language == "en" {
            return .english
        } else {
            return .russian
        }
    }

    var languageCode: String {
        switch self {
        case .english:
            return "en"
        case .russian:
            return "ru"
        }
    }

    var id: String {
        rawValue
    }
}

// MARK: - Help

enum Help: String, CaseIterable, Identifiable {
    case mail

    var id: String {
        rawValue
    }

    var localized: String {
        switch self {
        case .mail:
            return L10n.mail
        }
    }
}

// MARK: - Theme

enum Theme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String {
        rawValue
    }

    var localized: String {
        switch self {
        case .system:
            return L10n.Style.system
        case .light:
            return L10n.Style.light
        case .dark:
            return L10n.Style.dark
        }
    }
}
