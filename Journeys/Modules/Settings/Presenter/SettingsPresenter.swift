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
    private let displayDataFactory: SettingsDisplayDataFactory
    private let appRateManager: AppRateManagerProtocol
    private let notificationManager: NotificationsManagerProtocol
    
    private var hasUserEnabledNotifications: Bool?

    // MARK: Lifecycle

    init(interactor: SettingsInteractorInput,
         router: SettingsRouterInput,
         displayDataFactory: SettingsDisplayDataFactory,
         appRateManager: AppRateManagerProtocol,
         notificationManager: NotificationsManagerProtocol,
         moduleOutput: SettingsModuleOutput) {
        self.interactor = interactor
        self.router = router
        self.displayDataFactory = displayDataFactory
        self.appRateManager = appRateManager
        self.notificationManager = notificationManager
        self.moduleOutput = moduleOutput
    }
}

// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {
}

// MARK: SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {
    func viewDidAppear() {
        notificationManager.hasUserEnabledNotifications() { [weak self] result in
            self?.hasUserEnabledNotifications = result
            self?.view?.reloadView()
        }
    }
    
    func getDisplayData(for indexPath: IndexPath) -> SettingsCell.DisplayData {
        let row = indexPath.section == 0 ? 0 : indexPath.row + 1
        let cellType = SettingsCell.CellType.allCases[row]
        if cellType == .notifications {
            return displayDataFactory.displayData(for: cellType, switchValue: hasUserEnabledNotifications)
        }
        return displayDataFactory.displayData(for: cellType)
    }
    
    func getFooterText(for section: Int) -> String? {
        guard section == 0 else { return nil }
        if hasUserEnabledNotifications != true {
            return L10n.youNeetToTurnTheApplicationNotificationOn
        }
        return nil
    }

    func didSelectCell(at indexPath: IndexPath) {
        guard let setting = SettingsViewType(rawValue: indexPath.row) else { return }
        switch setting {
        case .rate:
            appRateManager.explicitlyRateApplication()
            view?.deselectCell(indexPath)

        case .help, .info, .language, .style:
            moduleOutput?.settingsModuleWantsToOpenSettingsSubModule(type: setting, animated: true)
        }
    }
}

// MARK: - SettingsInteractorOutput

extension SettingsPresenter: SettingsInteractorOutput {
}

// MARK: SettingsTableViewCellDelegate

extension SettingsPresenter: SettingsCellDelegate {
    func isAlertSwitchEnabled(completion: @escaping (Bool) -> Void) {
        notificationManager.hasUserEnabledNotificationsAtIOSLevel(completion: completion)
    }
    
    func switchValueWasTapped(_ value: Bool, completion: @escaping (Bool) -> Void) {
        notificationManager.toggleNotifications(isOn: value, completion: completion)
    }
}
