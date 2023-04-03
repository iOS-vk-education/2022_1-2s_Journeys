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
    func signOut()
    func getUserData()
    func deleteAccount(with password: String)
    func userEmail() -> String?
}

protocol AccountInfoModelOutput: AnyObject {
    func didObtainUserData(data: User)
    func didRecieveError(error: Error)
    func saveSuccesfull(for data: UserData)
    func deleteSuccesfull()
}
