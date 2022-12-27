//
//  AccountPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import Foundation

// MARK: - AccountPresenter

final class AccountPresenter {
    // MARK: - Public Properties

    weak var view: AccountViewInput?
    var model: AccountModelInput?
    weak var moduleOutout: AccountModuleOutput?

    private func showLoadingView() {
        moduleOutout?.showLoadingView()
    }
    
    private func hideLoadingView() {
        moduleOutout?.hideLoadingView()
    }
}

extension AccountPresenter: AccountModuleInput {
}

extension AccountPresenter: AccountViewOutput {
    func getUserEmail() -> String? {
        model?.getUserData()?.email
    }
    
    func didTapSaveButton() {
        view?.getCellsValues()
    }
    
    func didTapExitButton() {
        model?.signOut()
        moduleOutout?.logout()
    }

    func setCellsValues(newEmail: String?, password: String?, newPassword: String?) {
        guard let email = model?.getUserData()?.email else {
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
    
    func getCellsCount() -> Int {
        3
    }
    
    func getCellsDisplaydata(for indexPath: IndexPath) -> AccountCell.Displaydata? {
        switch indexPath.row {
        case 0:
            return AccountCell.Displaydata(text: "",
                                           placeHolder: "Новый Email",
                                           keyboardType: .default,
                                           secure: false)
        case 1:
            return AccountCell.Displaydata(text: "",
                                           placeHolder: "Пароль",
                                           keyboardType: .default,
                                           secure: true)
        case 2:
            return AccountCell.Displaydata(text: "",
                                           placeHolder: "Новый пароль",
                                           keyboardType: .default,
                                           secure: true)
        default:
            return nil
        }
    }
}

extension AccountPresenter: AccountModelOutput {
    func didRecieveError(error: Error) {
        hideLoadingView()
        view?.showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func saveSuccesfull() {
        hideLoadingView()
        view?.showAlert(title: "Данные сохранены", message: "Данные успешно сохранены")
    }
}
