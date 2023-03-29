//
//  AuthPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

import Foundation

// MARK: - AuthPresenter

final class AuthPresenter {
    
    enum ModuleType {
        case auth
        case registration
        
        var stringValue: String {
            switch self {
            case .auth: return  L10n.auth
            case .registration: return L10n.registration
            }
        }
        
        var otherModule: String {
            switch self {
            case .auth: return  L10n.registration
            case .registration: return L10n.auth
            }
        }
    }
    
    // MARK: - Public Properties

    weak var view: AuthViewInput?
    var model: AuthModelInput?
    weak var moduleOutput: AuthModuleOutput!
    
    private var moduleType: ModuleType

    init(moduleType: ModuleType) {
        self.moduleType = moduleType
    }
}

extension AuthPresenter: AuthModuleInput {
}

extension AuthPresenter: AuthViewOutput {
    
    func viewDidLoad() {
        if moduleType == .registration {
            view?.hideResetPasswordButton()
        } else {
            view?.showResetPasswordButton()
        }
    }
    
    func title() -> String {
        moduleType.stringValue
    }
    
    func buttonName() -> String {
        moduleType.otherModule
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch moduleType {
        case .registration: return AccountInfoCell.CellType.LoginInfo.allCases.count - 1
        case .auth: return AccountInfoCell.CellType.LoginInfo.allCases.count - 2
        }
    }
    
    func authData(email: String?, password: String?, confirmPassword: String? = nil) {
        if moduleType == .registration {
            guard password == confirmPassword else {
                view?.showAlert(title: "Ошибка", message: "Пароли не совпадают", textFieldPlaceholder: nil)
                return
            }
        }
        guard let email,
              let password else {
            view?.showAlert(title: "Ошибка",
                            message: "Заполните все поля для авторизации",
                            textFieldPlaceholder: nil)
            return
        }
        switch moduleType {
        case .auth:
            model?.login(email: email, password: password)
        case .registration:
            model?.createAccount(email: email, password: password)
        }
    }
    
    func displayData(for indexPath: IndexPath) -> AccountInfoCell.DisplayData? {
        //skip newPassword cell
        let row = indexPath.row == 2 ? 3 : indexPath.row
        guard AccountInfoCell.CellType.LoginInfo.allCases.count > row else { return nil }
        let cellType = AccountInfoCell.CellType.LoginInfo.allCases[row]
        let displayDataFactory = AccountInfoCellDisplayDataFactory()
        return displayDataFactory.loginInfoDisplayData(for: cellType)
    }
    
    func didTapContinueButton() {
        view?.cellsValues()
    }
    
    func didTapChangeScreenTypeButton() {
        switch moduleType {
        case .auth: moduleType = .registration
        case .registration: moduleType = .auth
        }
        view?.reload()
    }
    
    func didTapResetPasswordButton() {
        view?.showAlert(title: "Reset",
                        message: "Enter your email",
                        textFieldPlaceholder: "Enter email")
    }
    
    func emailForReset(_ email: String?) {
        guard let email else {
            view?.showAlert(title: "Ошибка",
                            message: "Email не заполнен",
                            textFieldPlaceholder: nil)
            return
        }
        model?.resetPassword(for: email)
        
    }
}

extension AuthPresenter: AuthModelOutput {
    func didRecieveError(error: Error) {
        view?.showAlert(title: "Error", message: "\(error.localizedDescription)", textFieldPlaceholder: nil)
    }
    
    func authSuccesfull() {
        view?.showTabbar()
        moduleOutput.authModuleWantsToBeClosed()
    }
    
    func resetSuccesfull(for email: String) {
        view?.showAlert(title: L10n.Alerts.Titles.success,
                        message: "\(L10n.Alerts.Messages.passwordResetDone) (\(email))",
                        textFieldPlaceholder: nil)
    }
}
