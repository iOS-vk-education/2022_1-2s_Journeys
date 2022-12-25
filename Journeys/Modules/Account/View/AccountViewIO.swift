//
//  AccountViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import Foundation


// MARK: - Account ViewInput

protocol AccountViewInput: AnyObject {
    func getCellsValues()
    func showAlert(title: String, message: String)
}

// MARK: - Account ViewOutput

protocol AccountViewOutput: AnyObject {
    func getCellsCount() -> Int
    func getCellsDisplaydata(for indexPath: IndexPath) -> AccountCell.Displaydata?
    
    func didTapSaveButton()
    func didTapExitButton()
    
    func setCellsValues(newEmail: String?, password: String?, newPassword: String?)
}
