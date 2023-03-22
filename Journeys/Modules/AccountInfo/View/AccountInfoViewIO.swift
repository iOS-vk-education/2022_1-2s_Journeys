//
//  AccountInfoViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

import Foundation


// MARK: - AccountInfo ViewInput

protocol AccountInfoViewInput: AnyObject {
    func reloadData()
    func cellsValues(from section: Int)
    func showAlert(title: String,
                   message: String,
                   textFieldPlaceholder: String?)
    func showLoadingView()
    func hideLoadingView()
}

// MARK: - AccountInfo ViewOutput

protocol AccountInfoViewOutput: AnyObject {
    func viewDidLoad()
    func header(for section: Int) -> String?
    func displayData(for indexPath: IndexPath) -> AccountInfoCell.DisplayData?
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int?
    
    func didTapBackBarButton()
    func didTapSaveButton()
    func didTapExitButton()
    func didTapDeleteAccountButton()
    
    func deleteAccount(with passwordApprove: String?)
    
    func setCellsValues(newEmail: String?, password: String?, newPassword: String?)
}
