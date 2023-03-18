//
//  AccountPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import Foundation

// MARK: - AccountPresenter

final class AccountInfoPresenter {
    enum Sections: Int, CaseIterable {
        case personalInfo = 0
        case loginInfo
        
        var stringValue: String {
            switch self {
            case .personalInfo: return  L10n.personalInfo
            case .loginInfo: return L10n.loginInfo
            }
        }
    }
    
    // MARK: - Public Properties

    weak var view: AccountInfoViewInput?
    var model: AccountInfoModelInput?
    weak var moduleOutout: AccountInfoModuleOutput?
    
    private var userData: User?

    private func showLoadingView() {
        moduleOutout?.showLoadingView()
    }
    
    private func hideLoadingView() {
        moduleOutout?.hideLoadingView()
    }
}

extension AccountInfoPresenter: AccountInfoModuleInput {
}

extension AccountInfoPresenter: AccountInfoViewOutput {
    func viewDidLoad() {
        model?.getUserData()
    }
    
    func header(for section: Int) -> String? {
        guard Sections.allCases.indices.contains(section) else { return nil }
        return Sections.allCases[section].stringValue
    }
    
    func didTapBackBarButton() {
        moduleOutout?.accountInfoModuleWantToBeClosed()
    }
    
    func didTapSaveButton() {
        view?.cellsValues(from: Sections.loginInfo.rawValue)
    }
    
    func didTapExitButton() {
        model?.signOut()
        moduleOutout?.logout()
    }
    
    func didTapDeleteAccountButton() {
        print("Delete acc")
    }
    
    func displayData(for indexPath: IndexPath) -> AccountInfoCell.DisplayData? {
        guard Sections.allCases.indices.contains(indexPath.section) else { return nil }
        let section = Sections.allCases[indexPath.section]
        switch section {
        case .loginInfo:
            guard AccountInfoCell.CellType.LoginInfo.allCases.indices.contains(indexPath.row) else { return nil }
            let cellType = AccountInfoCell.CellType.LoginInfo.allCases[indexPath.row]
            let displayDataFactory = AccountInfoCellDisplayDataFactory()
            if cellType == .email {
                return displayDataFactory.loginInfoDisplayData(for: cellType, value: userData?.email)
            }
            return displayDataFactory.loginInfoDisplayData(for: cellType)
        case .personalInfo:
            guard AccountInfoCell.CellType.PersonalInfo.allCases.indices.contains(indexPath.row) else { return nil }
            let cellType = AccountInfoCell.CellType.PersonalInfo.allCases[indexPath.row]
            let displayDataFactory = AccountInfoCellDisplayDataFactory()
            return displayDataFactory.personalInfoDisplayData(for: cellType, value: "Data")
        default:
            return nil
        }
    }
    
    func numberOfSections() -> Int {
        Sections.allCases.count
    }
    func numberOfRows(in section: Int) -> Int? {
        guard Sections.allCases.indices.contains(section) else { return nil }
        let section = Sections.allCases[section]
        switch section {
        case .loginInfo: return AccountInfoCell.CellType.LoginInfo.allCases.count
        case .personalInfo: return AccountInfoCell.CellType.PersonalInfo.allCases.count
        }
    }

    func setCellsValues(newEmail: String?, password: String?, newPassword: String?) {
        guard let email = userData?.email else {
            view?.showAlert(title: "Ошибка", message: "Возникли проблемы с вашим Email адресом, перезайдите в аккаунт")
            return
        }
        guard let password else {
            view?.showAlert(title: "Ошибка", message: "Введите текущий пароль для смены данных")
            return
        }
        if let newEmail {
            if let newPassword {
                model?.saveEmailAndPassword(email: email,
                                           newEmail: newEmail,
                                           password: password,
                                           newPassword: newPassword)
                showLoadingView()
                return
            } else {
                model?.saveEmail(email: email, newEmail: newEmail, password: password)
                showLoadingView()
                return
            }
        }
        if let newPassword {
            model?.savePassword(email: email, password: password, newPassword: newPassword)
            showLoadingView()
            return
        }
        view?.showAlert(title: "Ошибка", message: "Заполните поля для изменения данных")
    }
}

extension AccountInfoPresenter: AccountInfoModelOutput {
    func didObtainUserData(data: User) {
        userData = data
        view?.reloadData()
    }
    
    func didRecieveError(error: Error) {
        hideLoadingView()
        view?.showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func saveSuccesfull() {
        hideLoadingView()
        view?.showAlert(title: "Данные сохранены", message: "Данные успешно сохранены")
    }
}
