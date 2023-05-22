//
//  AccountInfoModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation

protocol AccountInfoModelInput: AnyObject {
    func saveEmail(email: String, newEmail: String, password: String, completion: (() -> Void)?)
    func savePassword(email: String, password: String, newPassword: String)
    func saveUserData(_ data: User)
    func signOut()
    func getUserData()
    func deleteUser(with password: String)
}

protocol AccountInfoModelOutput: AnyObject {
    func didObtainUserData(data: User)
    func didRecieveError(error: Error)
    func saveSuccesfull()
    func didStoreData(_ data: AccountInfoPresenter.StorableData)
    func deleteSuccesfull()
}
