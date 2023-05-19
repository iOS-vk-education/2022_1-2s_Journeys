//
//  AccountViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

import Foundation


// MARK: - Account ViewInput

protocol AccountViewInput: AnyObject {
    func deselectCell(_ indexPath: IndexPath)
    func reloadView()
    
    func showAlert(title: String,
                   message: String)
}

// MARK: - Account ViewOutput

protocol AccountViewOutput: AnyObject {
    func viewDidAppear()
    func displayData(for indexPath: IndexPath) -> SettingsCell.DisplayData?
    func didSelectCell(at indexPath: IndexPath)
    func numberOfRows(in section: Int) -> Int
    func username() -> String
}
