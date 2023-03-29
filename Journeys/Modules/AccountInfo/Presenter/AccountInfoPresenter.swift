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
        case personalInfo
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
    
    private struct ChangeUserData {
        var needToChangePassword: Bool = false
        var needToChangeEmail: Bool = false
        
        enum ThingsToChange {
            case password
            case email
            case emailAndPassword
            case nothing
        }
        
        func thingsToChange() -> ThingsToChange {
            if needToChangeEmail && needToChangePassword {
                return ThingsToChange.emailAndPassword
            } else if needToChangeEmail {
                return ThingsToChange.email
            } else if needToChangePassword {
                return ThingsToChange.password
            } else {
                return ThingsToChange.nothing
            }
        }
    }
    
    private func showLoadingView() {
        view?.showLoadingView()
    }
    
    private func hideLoadingView() {
        view?.hideLoadingView()
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
    }
    
    func didTapDeleteAccountButton() {
        view?.showAlert(title: L10n.Alerts.Titles.deleteAccount,
                        message: L10n.Alerts.Messages.deleteAccount,
                        textFieldPlaceholder: L10n.Alerts.Messages.enterYourPassword)
    }
    
    func displayData(for indexPath: IndexPath) -> AccountInfoCell.DisplayData? {
        guard Sections.allCases.count > indexPath.section else { return nil }
        let section = Sections.allCases[indexPath.section]
        switch section {
        case .loginInfo:
            guard AccountInfoCell.CellType.LoginInfo.allCases.count > indexPath.row else { return nil }
            let cellType = AccountInfoCell.CellType.LoginInfo.allCases[indexPath.row]
            let displayDataFactory = AccountInfoCellDisplayDataFactory()
            if cellType == .email {
                return displayDataFactory.loginInfoDisplayData(for: cellType, value: userData?.email)
            }
            return displayDataFactory.loginInfoDisplayData(for: cellType)
        case .personalInfo:
            guard AccountInfoCell.CellType.PersonalInfo.allCases.count > indexPath.row else { return nil }
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
        guard Sections.allCases.count > section else { return nil }
        let section = Sections.allCases[section]
        switch section {
        case .loginInfo: return AccountInfoCell.CellType.LoginInfo.allCases.count
        case .personalInfo: return AccountInfoCell.CellType.PersonalInfo.allCases.count
        }
    }

    func setCellsValues(newEmail: String?, password: String?, newPassword: String?, confirmPassword: String?) {
        guard let email = userData?.email else {
            view?.showAlert(title: "Ошибка",
                            message: "Возникли проблемы с вашим Email адресом, перезайдите в аккаунт",
                            textFieldPlaceholder: nil)
            return
        }
        guard let password else {
            view?.showAlert(title: "Ошибка",
                            message: "Введите текущий пароль для смены данных",
                            textFieldPlaceholder: nil)
            return
        }
        
        var changeUserData = ChangeUserData()
        if let newPassword {
            guard confirmPassword == newPassword else {
                view?.showAlert(title: "Ошибка",
                                message: "Новые пароли не совпадают!",
                                textFieldPlaceholder: nil)
                return
            }
            changeUserData.needToChangePassword = true
        }
        
        if newEmail != nil && newEmail != email {
            changeUserData.needToChangeEmail = true
        }
        
        
        switch changeUserData.thingsToChange() {
        case .email:
            model?.saveEmail(email: email, newEmail: newEmail ?? "", password: password)
        case .password:
            model?.savePassword(email: email, password: password, newPassword: newPassword ?? "")
        case .emailAndPassword:
            model?.saveEmailAndPassword(email: email,
                                        newEmail: newEmail ?? "",
                                        password: password,
                                        newPassword: newPassword ?? "")
        case .nothing:
            return
        default:
            return
        }
        showLoadingView()
        return
    }
    
    func deleteAccount(with passwordApprove: String?) {
        guard let passwordApprove else {
            view?.showAlert(title: "Enter your password",
                            message: "Account was not deleted, pleace try again",
                            textFieldPlaceholder: nil)
            return
        }
        model?.deleteAccount(with: passwordApprove)
    }
}

extension AccountInfoPresenter: AccountInfoModelOutput {
    func didObtainUserData(data: User) {
        userData = data
        view?.reloadData()
    }
    
    func didRecieveError(error: Error) {
        hideLoadingView()
        view?.showAlert(title: "Error",
                        message: error.localizedDescription,
                        textFieldPlaceholder: nil)
    }
    
    func saveSuccesfull() {
        hideLoadingView()
        view?.showAlert(title: "Данные сохранены",
                        message: "Данные успешно сохранены",
                        textFieldPlaceholder: nil)
        view?.clearCellsTextFields(in: Sections.loginInfo.rawValue)
    }
    
    func deleteSuccesfull() {
        view?.showAlert(title: L10n.Alerts.Titles.success,
                        message: L10n.Alerts.Messages.accountWasDeleted,
                        textFieldPlaceholder: nil)
    }
    
}
