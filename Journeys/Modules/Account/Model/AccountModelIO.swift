//
//  AccountModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation

protocol AccountModelInput: AnyObject {
    func saveEmail(email: String, newEmail: String, password: String)
    func savePassword(email: String, password: String, newPassword: String)
    func saveEmailAndPassword(email: String, newEmail: String, password: String, newPassword: String)
    func signOut()
    func getUserData() -> User?
}

protocol AccountModelOutput: AnyObject {
    func didRecieveError(error: Error)
    func saveSuccesfull()
}
