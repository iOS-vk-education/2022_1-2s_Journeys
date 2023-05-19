//
//  Errors.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation

enum Errors: Error {
    case obtainDataError
    case saveDataError
    case deleteDataError
    case authError
    case signOutError
}

enum FBError: Error {
    case noData
    case error
    case authError
    case signOutError
}

enum NetworkError: Error {
    case badResponse
}
