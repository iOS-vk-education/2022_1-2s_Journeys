//
//  AccountPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

import Foundation
import UIKit

// MARK: - AccountPresenter

final class AccountPresenter {
    
    // MARK: - Public Properties
    weak var view: AccountViewInput?
    weak var moduleOutput: AccountModuleOutput?
    var model: AccountModelInput?
    
    // MARK: - Private Properties
    private let displayDataFactory = SettingsDisplayDataFactory()
    private let firebaseService: FirebaseServiceProtocol
    
    private var userData: User?
    private var isAvatarLoaded: Bool = false
    
    init(firebaseService: FirebaseServiceProtocol,
         moduleOutput: AccountModuleOutput) {
        self.firebaseService = firebaseService
        self.moduleOutput = moduleOutput
    }

}

extension AccountPresenter: AccountModuleInput {
}

extension AccountPresenter: AccountViewOutput {
    func viewWillAppear() {
        isAvatarLoaded = false
        model?.getUserData()
        model?.obtainAvatar() { [weak self] image in
            guard let self else { return }
            self.isAvatarLoaded = true
            self.view?.setImageView(image: image, didFinishLoading: self.isAvatarLoaded)
        }
    }
    
    func deleteAvatar() {
        model?.deleteAvatar()
    }
    
    func setAvatar(_ image: UIImage) {
        model?.storeAvatar(image) { [weak self] image in
            guard let self else { return }
            self.view?.setImageView(image: image, didFinishLoading: self.isAvatarLoaded)
        }
    }
    
    func username() -> String {
        guard let fullName = userData?.fullName() else {
            return ""
        }
        return fullName
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
            moduleOutput?.accountModuleWantsToOpenAccountInfoModule(with: userData)
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

extension AccountPresenter: AccountModelOutput {
    func didDeleteImage() {
        isAvatarLoaded = true
        view?.setImageView(image: nil, didFinishLoading: isAvatarLoaded)
    }
    
    func didObtainUserData(data: User) {
        userData = data
        view?.reloadView()
    }
    
    func didRecieveError(error: Error) {
        view?.showAlert(title: "Error",
                        message: error.localizedDescription)
    }
}
