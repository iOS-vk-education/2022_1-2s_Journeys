//
//  Errors.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation

enum Errors: String {
    case obtainDataError
    case saveDataError
    case deleteDataError
}

enum FBError: Error {
    case noData
    case error
}
