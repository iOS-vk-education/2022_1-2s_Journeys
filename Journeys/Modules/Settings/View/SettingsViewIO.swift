//
//
//  SettingsViewIO.swift
//  DrPillman
//
//  Created by puzzzik on 17/05/2022.
//

import Foundation

// MARK: - SettingsViewOutput

protocol SettingsViewOutput: AnyObject {
    func getDisplayData(for indexPath: IndexPath) -> SettingsCell.DisplayData
    func getFooterText(for section: Int) -> String?
    func didSelectCell(at indexPath: IndexPath)
    func viewWillAppear()
    func didTapBackBarButton()
}

// MARK: - SettingsViewInput

protocol SettingsViewInput: AnyObject {
    func deselectCell(_ indexPath: IndexPath)
    func reloadView()
    func openMailView()
}
