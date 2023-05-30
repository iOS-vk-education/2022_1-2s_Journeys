//
//
//  SettingsPresenter.swift
//  DrPillman
//
//  Created by puzzzik on 17/05/2022.
//

import Foundation
import UIKit

// MARK: - SettingsPresenter

final class SettingsPresenter {
    // MARK: Internal Properties

    weak var view: SettingsViewInput?
    weak var moduleOutput: SettingsModuleOutput?

    // MARK: Private Properties

    private let interactor: SettingsInteractorInput
    private let router: SettingsRouterInput
    private let appRateManager: AppRateManagerProtocol
    private let notificationManager: NotificationsManagerProtocol = NotificationsManager.shared
    
    private var areNotificationsEnabledAtIOSLevel: Bool?
    private var areNotificationsEnabled: Bool?

    // MARK: Lifecycle

    init(interactor: SettingsInteractorInput,
         router: SettingsRouterInput,
         appRateManager: AppRateManagerProtocol,
         moduleOutput: SettingsModuleOutput) {
        self.interactor = interactor
        self.router = router
        self.appRateManager = appRateManager
        self.moduleOutput = moduleOutput
    }
}

// MARK: SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {
    func viewWillAppear() {
    }
    
    func getDisplayData(for indexPath: IndexPath) -> SettingsCell.DisplayData {
        let cellType = SettingsCell.CellType.Settings.allCases[indexPath.row]
        let displayDataFactory = SettingsDisplayDataFactory()
        return displayDataFactory.settingsDisplayData(for: cellType)
    }

    func didSelectCell(at indexPath: IndexPath) {
        guard let setting = SettingsViewType(rawValue: indexPath.row) else { return }
        switch setting {
        case .rate:
            appRateManager.explicitlyRateApplication()
            view?.deselectCell(indexPath)
        case .help:
            view?.openMailView()
        case .info, .language, .style:
            moduleOutput?.settingsModuleWantsToOpenSettingsSubModule(type: setting, animated: true)
        }
    }
    
    func didTapBackBarButton() {
        moduleOutput?.settingsModuleWantsToBeClosed()
    }
}

// MARK: - SettingsInteractorOutput

extension SettingsPresenter: SettingsInteractorOutput {
}

// MARK: SettingsTableViewCellDelegate

extension SettingsPresenter: SettingsCellDelegate {
    func isAlertSwitchEnabled() -> Bool? {
        areNotificationsEnabledAtIOSLevel
    }
    
    func switchWasTapped(_ value: Bool, completion: @escaping (Bool) -> Void) {
        notificationManager.toggleNotifications(isOn: value, completion: completion)
    }
}

// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {
}
