//
//  LocalizationSystem.swift
//  Journeys
//
//  Created by Сергей Адольевич on 09.03.2023.
//

import Foundation

// MARK: - LocalizationSystem

class LocalizationSystem: NSObject {
    var bundle: Bundle

    var locale: Locale {
        let lang = getLanguage()
        let locale = Locale(identifier: lang)
        return locale
    }

    class var sharedInstance: LocalizationSystem {
        struct Singleton {
            static let instance: LocalizationSystem = .init()
        }
        return Singleton.instance
    }

    override init() {
        bundle = Bundle.main
        super.init()
    }

    func localizedString(_ key: String, _ table: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: table)
    }

    func setLanguage(languageCode: String) {
        guard var appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages")
            as? [String] else { return }
        appleLanguages.remove(at: 0)
        appleLanguages.insert(languageCode, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize() // needs restrat

        if let languageDirectoryPath = Bundle.main.path(forResource: languageCode, ofType: "lproj") {
            bundle = Bundle(path: languageDirectoryPath) ?? Bundle.main
            print(Bundle(path: languageDirectoryPath))
        } else {
            resetLocalization()
        }
    }

    // MARK: - resetLocalization

    func resetLocalization() {
        bundle = Bundle.main
    }

    // MARK: - getLanguage

    func getLanguage() -> String {
        guard let appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages")
            as? [String] else { return "ru" }
        let prefferedLanguage = appleLanguages[0]
        if prefferedLanguage.contains("-") {
            let array = prefferedLanguage.components(separatedBy: "-")
            return array[0]
        }
        return prefferedLanguage
    }
}
