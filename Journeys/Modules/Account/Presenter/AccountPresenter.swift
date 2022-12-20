//
//  AccountPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

// MARK: - AccountPresenter

final class AccountPresenter {
    // MARK: - Public Properties

    weak var view: AccountViewInput!

}

extension AccountPresenter: AccountModuleInput {
}

extension AccountPresenter: AccountViewOutput {
}
