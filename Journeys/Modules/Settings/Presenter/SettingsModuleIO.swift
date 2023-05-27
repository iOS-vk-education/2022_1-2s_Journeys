//
//  SettingsSettingsModuleInput.swift
//  DrPillman
//
//  Created by puzzzik on 17/05/2022.
//  Copyright © 2022 DrPillman. All rights reserved.
//

// MARK: - SettingsModuleInput

protocol SettingsModuleInput: AnyObject {
}

// MARK: - SettingsModuleOutput

protocol SettingsModuleOutput: AnyObject {
    func settingsModuleWantsToOpenSettingsSubModule(type: SettingsViewType, animated: Bool)
    func settingsModuleWantsToBeClosed()
}
