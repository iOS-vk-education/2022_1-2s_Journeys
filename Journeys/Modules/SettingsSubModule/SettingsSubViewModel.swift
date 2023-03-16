//
//  SettingsSubViewModel.swift
//  DrPillman
//
//  Created by Анастасия Ищенко on 10.03.2023.
//

import Foundation
import Combine
import UIKit

final class SettingsViewModel: ObservableObject {
    @Published var viewType: SettingsViewType
    @Published var languageTypes: [Language] = Language.allCases
    @Published var styles: [Theme] = Theme.allCases
    @Published var helps: [Help] = Help.allCases

    @Published var selectedLanguage: Language = .selectedLanguage

    @Published var selectedStyle: Theme = .current

    init(viewType: SettingsViewType) {
        self.viewType = viewType
    }

    func styleDidChange(_ theme: Theme) {
        selectedStyle = theme
        theme.setActive()
    }

    func languageDidChange(_ language: Language) {
        let localizationSystem = LocalizationSystem.sharedInstance
        localizationSystem.setLanguage(languageCode: language.languageCode)
        print(localizationSystem.getLanguage())
        selectedLanguage = language
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.coordinator?.reload()
    }

    func helpButtonDidTap(_ help: Help) {
    }
}
