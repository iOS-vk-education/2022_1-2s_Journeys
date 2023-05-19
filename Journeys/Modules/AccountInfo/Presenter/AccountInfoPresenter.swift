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
    
    enum StorableData {
        case personalInfo(User)
        case email(String?)
        case password
    }
    
    struct LoginInfo {
        var newEmail: String?
        var password: String?
        var newPassword: String?
        var confirmPassword: String?
        
        internal init(newEmail: String? = nil,
                      password: String? = nil,
                      newPassword: String? = nil,
                      confirmPassword: String? = nil) {
            self.newEmail = newEmail
            self.password = password
            self.newPassword = newPassword
            self.confirmPassword = confirmPassword
        }
    }
    
    // MARK: - Public Properties
    
    weak var view: AccountInfoViewInput?
    var model: AccountInfoModelInput?
    weak var moduleOutout: AccountInfoModuleOutput?
    
    private var userData: User?
    
    private let dataStoreQueue = DispatchQueue.global()
    private let dataStoreDispatchGroup = DispatchGroup()
    private var didReceiveAnyError: Bool = false
    
    init(userData: User?) {
        self.userData = userData
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
        if userData == nil {
            model?.getUserData()
        }
    }
    
    func header(for section: Int) -> String? {
        guard Sections.allCases.indices.contains(section) else { return nil }
        return Sections.allCases[section].stringValue
    }
    
    func didTapBackBarButton() {
        moduleOutout?.accountInfoModuleWantToBeClosed()
    }
    
    func didTapSaveButton() {
        var userNewData = User(email: userData?.email)
        for personalInfo in AccountInfoCell.CellType.PersonalInfo.allCases {
            let cellValue = view?.cellValue(for: IndexPath(row: personalInfo.rawValue,
                                                           section: Sections.personalInfo.rawValue))
            switch personalInfo {
            case .firstName: userNewData.name = cellValue
            case .lastName: userNewData.lastName = cellValue
            default: break
            }
        }
        if userData?.name != userNewData.name || userData?.lastName != userNewData.lastName {
            saveUserData(userNewData)
        }
        
        var loginNewData = LoginInfo()
        for loginInfo in AccountInfoCell.CellType.LoginInfo.allCases {
            let cellValue = view?.cellValue(for: IndexPath(row: loginInfo.rawValue,
                                                           section: Sections.loginInfo.rawValue))
            switch loginInfo {
            case .email: loginNewData.newEmail = cellValue
            case .password: loginNewData.password = cellValue
            case .confirmPassword: loginNewData.confirmPassword = cellValue
            case .newPassword: loginNewData.newPassword = cellValue
            default: break
            }
        }
        saveLoginInfo(loginNewData)
    }
    
    private func saveUserData(_ userInfo: User) {
        dataStoreDispatchGroup.enter()
        dataStoreQueue.async(group: dataStoreDispatchGroup) { [weak self] in
            self?.model?.saveUserData(userInfo)
        }
    }
    
    private func saveLoginInfo(_ loginInfo: LoginInfo) {
        guard let email = userData?.email else {
            view?.showAlert(title: "Ошибка",
                            message: "Возникли проблемы с вашим Email адресом, перезайдите в аккаунт",
                            textFieldPlaceholder: nil)
            return
        }
        if let newEmail = loginInfo.newEmail, newEmail != email {
            saveUsersEmailIfNeeded(currentEmail: email,
                                   newEmail: newEmail,
                                   password: loginInfo.password) { [weak self] newEmail in
                self?.saveUsersPasswordIfNeeded(email: newEmail,
                                                password: loginInfo.password,
                                                newPassword: loginInfo.newPassword,
                                                confirmPassword: loginInfo.confirmPassword)
            }
        } else {
            saveUsersPasswordIfNeeded(email: email,
                                      password: loginInfo.password,
                                      newPassword: loginInfo.newPassword,
                                      confirmPassword: loginInfo.confirmPassword)
        }
        showLoadingView()
    }
    
    private func saveUsersEmailIfNeeded(currentEmail: String,
                                        newEmail: String,
                                        password: String?,
                                        completion: @escaping (String) -> Void) {
        guard let password else {
            view?.showAlert(title: "Ошибка",
                            message: "Для сменя информации для авторизации необходимо ввести пароль",
                            textFieldPlaceholder: nil)
            return
        }
        dataStoreDispatchGroup.enter()
        dataStoreQueue.async(group: dataStoreDispatchGroup) { [weak self] in
            self?.model?.saveEmail(email: currentEmail, newEmail: newEmail, password: password) { [weak self] in
                guard let self else { return }
                completion(newEmail)
            }
        }
    }
    
    private func saveUsersPasswordIfNeeded(email: String,
                                           password: String?,
                                           newPassword: String?,
                                           confirmPassword: String?) {
        if let newPassword {
            guard let password else {
                view?.showAlert(title: "Ошибка",
                                message: "Для сменя информации для авторизации необходимо ввести пароль",
                                textFieldPlaceholder: nil)
                return
            }
            guard confirmPassword == newPassword else {
                view?.showAlert(title: "Ошибка",
                                message: "Новые пароли не совпадают!",
                                textFieldPlaceholder: nil)
                return
            }
            dataStoreDispatchGroup.enter()
            dataStoreQueue.async(group: dataStoreDispatchGroup) { [weak self] in
                self?.model?.savePassword(email: email, password: password, newPassword: newPassword)
            }
        }
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
            guard let userData else {
                return displayDataFactory.personalInfoDisplayData(for: cellType)
            }
            switch cellType {
            case .firstName: return displayDataFactory.personalInfoDisplayData(for: cellType, value: userData.name)
            case .lastName: return displayDataFactory.personalInfoDisplayData(for: cellType, value: userData.lastName)
            default: return nil
            }
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
    
    func setUserInfoCellsValues(firstName: String?, lastName: String?) {
        guard let email = userData?.email else { return }
        model?.saveUserData(User(email: email, name: firstName, lastName: lastName))
        showLoadingView()
    }
    
    func deleteAccount(with passwordApprove: String?) {
        guard let passwordApprove else {
            view?.showAlert(title: "Enter your password",
                            message: "Account was not deleted, pleace try again",
                            textFieldPlaceholder: nil)
            return
        }
        model?.deleteUser(with: passwordApprove)
    }
}

extension AccountInfoPresenter: AccountInfoModelOutput {
    func didObtainUserData(data: User) {
        userData = data
        view?.reloadData()
    }
    
    func didRecieveError(error: Error) {
        self.view?.hideLoadingView()
        didReceiveAnyError = true
        view?.showAlert(title: "Error",
                        message: error.localizedDescription,
                        textFieldPlaceholder: nil)
        //        dataStoreDispatchGroup.leave()
    }
    
    func didStoreData(_ data: StorableData) {
        switch data {
        case .personalInfo(let newUserData):
            userData = newUserData
        case .email(let newEmail):
            if let newEmail {
                userData?.email = newEmail
                guard let userData else { return }
                model?.saveUserData(userData)
            }
        default:
            break
        }
        dataStoreDispatchGroup.leave()
        
        dataStoreDispatchGroup.notify(queue: dataStoreQueue) { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.reloadData()
                self.view?.hideLoadingView()
                if !self.didReceiveAnyError {
                    self.saveSuccesfull()
                }
                self.didReceiveAnyError = false
            }
        }
    }
    
    func saveSuccesfull() {
        view?.showAlert(title: "Данные сохранены",
                        message: "Данные успешно сохранены",
                        textFieldPlaceholder: nil)
        var indexPaths: [IndexPath] = []
        for loginInfo in AccountInfoCell.CellType.LoginInfo.allCases {
            if loginInfo != .email {
                indexPaths.append(IndexPath(row: loginInfo.rawValue, section: Sections.loginInfo.rawValue))
            }
        }
        view?.clearCellsTextFields(at: indexPaths)
    }
    
    func deleteSuccesfull() {
        view?.showAlert(title: L10n.Alerts.Titles.success,
                        message: L10n.Alerts.Messages.accountWasDeleted,
                        textFieldPlaceholder: nil)
    }
    
}
