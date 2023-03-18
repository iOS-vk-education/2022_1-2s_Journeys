//
//  AccountInfoModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation

protocol AccountInfoModelInput: AnyObject {
    func saveEmail(email: String, newEmail: String, password: String)
    func savePassword(email: String, password: String, newPassword: String)
    func saveEmailAndPassword(email: String, newEmail: String, password: String, newPassword: String)
    func signOut()
    func getUserData()
}

protocol AccountInfoModelOutput: AnyObject {
    func didObtainUserData(data: User)
    func didRecieveError(error: Error)
    func saveSuccesfull()
}
