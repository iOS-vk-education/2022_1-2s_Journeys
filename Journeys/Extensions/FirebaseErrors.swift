//
//  FirebaseErrors.swift
//  Journeys
//
//  Created by Сергей Адольевич on 29.05.2023.
//

import Foundation
import FirebaseAuth

extension AuthErrorCode.Code {
    var description: String? {
        switch self {
        case .emailAlreadyInUse:
            return L10n.FirebaseAuth.Errors.emailAlreadyInUse
        case .userDisabled:
            return L10n.FirebaseAuth.Errors.userDisabled
        case .operationNotAllowed:
            return L10n.FirebaseAuth.Errors.operationNotAllowed
        case .invalidEmail:
            return L10n.FirebaseAuth.Errors.invalidEmail
        case .wrongPassword:
            return L10n.FirebaseAuth.Errors.wrongPassword
        case .userNotFound:
            return L10n.FirebaseAuth.Errors.userNotFound
        case .networkError:
            return L10n.FirebaseAuth.Errors.networkError
        case .weakPassword:
            return L10n.FirebaseAuth.Errors.weakPassword
        case .missingEmail:
            return L10n.FirebaseAuth.Errors.missingEmail
        case .internalError:
            return L10n.FirebaseAuth.Errors.internalError
        case .invalidCustomToken:
            return L10n.FirebaseAuth.Errors.invalidCustomToken
        case .tooManyRequests:
            return L10n.FirebaseAuth.Errors.tooManyRequests
        default:
            return nil
        }
    }
}

public extension Error {
    var localizedDescription: String {
        let error = self as NSError
        if error.domain == AuthErrorDomain,
            let code = AuthErrorCode.Code(rawValue: error.code),
            let errorString = code.description {
                    return errorString
        }
        return error.localizedDescription
    }
}
