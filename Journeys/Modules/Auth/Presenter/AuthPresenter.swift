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

    weak var view: AuthViewInput!
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
    func getButtonName() -> String {
        switch moduleType {
        case .auth:
            return "Регистрация"
        case .registration:
            return "Авторизация"
        }
    }
    
    func didTapContinueButton() {
        view.getCellsValues()
    }
    
    func didTapChangeScreenTypeButton() {
        moduleOutput.authModuleWantsToChangeModulenType(currentType: moduleType)
    }
    
    func setCellsValues(email: String?, password: String?) {
        guard let email,
              let password else {
            switch moduleType {
            case .auth:
                view.showAlert(title: "Ошибка", message: "Заполните все поля для авторизации!")
            case .registration:
                view.showAlert(title: "Ошибка", message: "Заполните все поля для регистрации")
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
    
    func getTitle() -> String {
        switch moduleType {
        case .auth:
            return "Авторизация"
        case .registration:
            return "Регистрация"
        }
    }
    
    func getCellsCount() -> Int {
        2
    }
    
    func getCellsDisplaydata(for indexPath: IndexPath) -> AccountCell.Displaydata? {
        if indexPath.row == 0 {
            return AccountCell.Displaydata(text: "", placeHolder: "Email", keyboardType: .emailAddress, secure: false)
        } else if indexPath.row == 1 {
            return AccountCell.Displaydata(text: "", placeHolder: "Пароль", keyboardType: .default, secure: true)
        }
        return nil
    }
}

extension AuthPresenter: AuthModelOutput {
    func didRecieveError(error: Error) {
        view.showAlert(title: "Ошибка", message: "Произошла ошибка при регистрации. \(error.localizedDescription)")
    }
    
    func authSuccesfull() {
        moduleOutput.authModuleWantsToOpenTripsModule()
    }
}
