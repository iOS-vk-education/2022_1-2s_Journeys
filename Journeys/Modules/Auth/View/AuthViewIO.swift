//
//  AuthViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

import Foundation


// MARK: - Auth ViewInput

protocol AuthViewInput: AnyObject {
    func getCellsValues()
    func showAlert(title: String, message: String)
    func showTabbar()
}

// MARK: - Auth ViewOutput

protocol AuthViewOutput: AnyObject {
    func title() -> String
    func displayData(for indexPath: IndexPath) -> AccountInfoCell.DisplayData?
    func buttonName() -> String
    
    func numberOfRows(in section: Int) -> Int
    
    func didTapContinueButton()
    func didTapChangeScreenTypeButton()
    
    func setCellsValues(email: String?, password: String?)
}
