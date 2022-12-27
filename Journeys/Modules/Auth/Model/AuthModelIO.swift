//
//  AuthModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation

protocol AuthModelInput: AnyObject {
    func createAccount(email: String, password: String)
    func login(email: String, password: String)
}

protocol AuthModelOutput: AnyObject {
    func didRecieveError(error: Error)
    func authSuccesfull()
}
