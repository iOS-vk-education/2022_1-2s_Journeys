//
//  Theme+Userdefaults.swift
//  Journeys
//
//  Created by Сергей Адольевич on 09.03.2023.
//

import Foundation

// MARK: - Persist

@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension Theme {
    // Обертка для UserDefaults
    @Persist(key: "jrns.app_theme", defaultValue: Theme.light.rawValue)
    private static var appTheme: String

    // Сохранение темы в UserDefaults
    func save() {
        Theme.appTheme = rawValue
    }

    // Текущая тема приложения
    static var current: Theme {
        Theme(rawValue: appTheme) ?? .light
    }
}
