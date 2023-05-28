//
//  SelectedEventsViewIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation

// MARK: - Events ViewInput
protocol SelectedEventsViewInput: AnyObject {
    func reload()
    func show(error: Error)
    func reloadImage()
}

// MARK: - Events ViewOutput
protocol SelectedEventsViewOutput: AnyObject {
    func didTapCloseButton()
    func didLoadView()
    func displayingData() -> [Event]?
    func displayingCreatedEvent(for row: Int) -> FavoriteEventCell.DisplayData?
}
