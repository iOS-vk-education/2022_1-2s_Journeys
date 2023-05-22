//
//  AccountInfoCellDisplayDataFactory.swift
//  Journeys
//
//  Created by Сергей Адольевич on 18.03.2023.
//

import Foundation

// MARK: - AccountInfoCellDisplayDataFactory

final class AccountInfoCellDisplayDataFactory {
    
    // MARK: Public
    
    func loginInfoDisplayData(for type: AccountInfoCell.CellType.LoginInfo,
                              value: String? = nil) -> AccountInfoCell.DisplayData? {
        switch type {
        case .email:
            return AccountInfoCell.DisplayData(text: value,
                                               placeHolder: type.placeholder,
                                               keyboardType: .emailAddress,
                                               secure: false)
        case .password, .newPassword, .confirmPassword:
            return AccountInfoCell.DisplayData(text: value,
                                               placeHolder: type.placeholder,
                                               keyboardType: .default,
                                               secure: true)
        default:
            return nil
        }
    }
    
    func personalInfoDisplayData(for type: AccountInfoCell.CellType.PersonalInfo,
                                 value: String? = nil) -> AccountInfoCell.DisplayData? {
        return AccountInfoCell.DisplayData(text: value,
                                           placeHolder: type.placeholder,
                                           keyboardType: .default,
                                           secure: false)
    }
}

