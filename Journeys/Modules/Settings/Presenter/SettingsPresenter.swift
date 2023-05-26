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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeAvtive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc
    private func didBecomeAvtive() {
        viewWillAppear()
    }
}

// MARK: SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {
    func viewWillAppear() {
        notificationManager.areNotificationsEnabledAtIOSLevel { [weak self] result in
            self?.areNotificationsEnabledAtIOSLevel = result
            if result {
                self?.notificationManager.hasUserEnabledNotifications { [weak self] result in
                    self?.areNotificationsEnabled = result
                    self?.view?.reloadView()
                }
            } else {
                self?.areNotificationsEnabled = false
            }
        }
    }
    
    func getDisplayData(for indexPath: IndexPath) -> SettingsCell.DisplayData {
        let row = indexPath.section == 0 ? 0 : indexPath.row + 1
        let cellType = SettingsCell.CellType.Settings.allCases[row]
        let displayDataFactory = SettingsDisplayDataFactory()
        if cellType == .notifications {
            return displayDataFactory.settingsDisplayData(for: cellType, switchValue: areNotificationsEnabled)
        }
        return displayDataFactory.settingsDisplayData(for: cellType)
    }
    
    func getFooterText(for section: Int) -> String? {
        guard section == 0 else { return nil }
        if areNotificationsEnabledAtIOSLevel != true {
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