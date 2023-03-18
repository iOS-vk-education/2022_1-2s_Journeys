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
    }
    
    // MARK: - Public Properties

    weak var view: AuthViewInput?
    var model: AuthModelInput!
    weak var moduleOutput: AuthModuleOutput!
    
    private var moduleType: ModuleType

    init(moduleType: ModuleType) {
        self.moduleType = moduleType
    }
}

extension AuthPresenter: AuthModuleInput {
}

extension AuthPresenter: AuthViewOutput {
    
    func title() -> String {
        switch moduleType {
        case .auth:
            return L10n.auth
        case .registration:
            return L10n.registration
        }
    }
    
    func buttonName() -> String {
        switch moduleType {
        case .auth:
            return L10n.registration
        case .registration:
            return L10n.auth
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 2
    }
    
    func setCellsValues(email: String?, password: String?) {
        guard let email,
              let password else {
            switch moduleType {
            case .auth:
                view?.showAlert(title: "Ошибка", message: "Заполните все поля для авторизации!")
            case .registration:
                view?.showAlert(title: "Ошибка", message: "Заполните все поля для регистрации")
            }
            return
        }
        switch moduleType {
        case .auth:
            model.login(email: email, password: password)
        case .registration:
            model.createAccount(email: email, password: password)
        }
    }
    
    func displayData(for indexPath: IndexPath) -> AccountInfoCell.DisplayData? {
        if indexPath.row == 0 {
            return AccountInfoCell.DisplayData(text: nil, placeHolder: "Email", keyboardType: .emailAddress, secure: false)
        } else if indexPath.row == 1 {
            return AccountInfoCell.DisplayData(text: nil, placeHolder: "Пароль", keyboardType: .default, secure: true)
        }
        return nil
    }
    
    func didTapContinueButton() {
        view?.getCellsValues()
    }
    
    func didTapChangeScreenTypeButton() {
        moduleOutput.authModuleWantsToChangeModulenType(currentType: moduleType)
    }
}

extension AuthPresenter: AuthModelOutput {
    func didRecieveError(error: Error) {
        view?.showAlert(title: "Error", message: "\(error.localizedDescription)")
    }
    
    func authSuccesfull() {
        view?.showTabbar()
        moduleOutput.authModuleWantsToOpenTripsModule()
    }
}
