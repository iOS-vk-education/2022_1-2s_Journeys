//
//  AuthViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

import Foundation
//import UIKit


// MARK: - Auth ViewInput

protocol AuthViewInput: AnyObject {
    func cellsValues()
    func showAlert(title: String,
                   message: String,
                   textFieldPlaceholder: String?)
    func showTabbar()
    func hideResetPasswordButton()
    func showResetPasswordButton()
    func reload()
}

// MARK: - Auth ViewOutput

protocol AuthViewOutput: AnyObject {
    func viewDidLoad()
    func title() -> String
    func displayData(for indexPath: IndexPath) -> AccountInfoCell.DisplayData?
    func buttonName() -> String
    
    func numberOfRows(in section: Int) -> Int
    
    func didTapContinueButton()
    func didTapChangeScreenTypeButton()
    func didTapResetPasswordButton()
    
    func emailForReset(_ email: String?)
    
    func authData(email: String?, password: String?, confirmPassword: String?)
}
