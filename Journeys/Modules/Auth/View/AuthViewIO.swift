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
    func getTitle() -> String
    func getCellsCount() -> Int
    func getCellsDisplaydata(for indexPath: IndexPath) -> AccountCell.Displaydata?
    func getButtonName() -> String
    
    func didTapContinueButton()
    func didTapChangeScreenTypeButton()
    
    func setCellsValues(email: String?, password: String?)
}
