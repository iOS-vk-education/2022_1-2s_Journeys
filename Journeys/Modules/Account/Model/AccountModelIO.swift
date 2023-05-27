//
//  AccountModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 20.05.2023.
//

import Foundation

protocol AccountModelInput: AnyObject {
    func getUserData()
}

protocol AccountModelOutput: AnyObject {
    func didObtainUserData(data: User)
    func didRecieveError(error: Error)
}
