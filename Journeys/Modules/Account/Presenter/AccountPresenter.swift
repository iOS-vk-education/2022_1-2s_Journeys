//
//  AccountPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

import Foundation

// MARK: - AccountPresenter

final class AccountPresenter {
    
    // MARK: - Public Properties
    weak var view: AccountViewInput?
    weak var moduleOutput: AccountModuleOutput?
    
    // MARK: - Private Properties
    private let displayDataFactory = SettingsDisplayDataFactory()
    private let firebaseService: FirebaseServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol,
         moduleOutput: AccountModuleOutput) {
        self.firebaseService = firebaseService
        self.moduleOutput = moduleOutput
    }

}

extension AccountPresenter: AccountModuleInput {
}

extension AccountPresenter: AccountViewOutput {
    func username() -> String {
        return "Петр Степаныч"
    }
    
    func displayData(for indexPath: IndexPath) -> SettingsCell.DisplayData? {
        guard SettingsCell.CellType.Account.allCases.count > indexPath.row else { return nil }
        let cellType = SettingsCell.CellType.Account.allCases[indexPath.row]
        return displayDataFactory.accountDisplayData(for: cellType)
    }

    func didSelectCell(at indexPath: IndexPath) {
        guard SettingsCell.CellType.Account.allCases.count > indexPath.row else { return }
        let nextPage = SettingsCell.CellType.Account.allCases[indexPath.row]
        switch nextPage {
        case .accountInfo:
            moduleOutput?.accountModuleWantsToOpenAccountInfoModule()
        case .stuffLists:
            moduleOutput?.accountModuleWantsToOpenStuffListsModule()
        case .settings:
            moduleOutput?.accountModuleWantsToOpenSettingsModule()
        default:
            break
        }
        view?.deselectCell(indexPath)
    }
    
    func numberOfRows(in section: Int) -> Int {
        return SettingsCell.CellType.Account.allCases.count
    }
}
