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
    func showChoiceAlert(title: String,
                         message: String,
                         agreeActionTitle: String,
                         disagreeActionTitle: String,
                         cellIndexPath: IndexPath)
    func endRefresh()
}

// MARK: - Events ViewOutput
protocol SelectedEventsViewOutput: AnyObject {
    func didTapCloseButton()
    func didLoadView()
    func displayingData() -> [Event]?
    func displayingCreatedEvent(for row: Int, cellType: FavoriteEventCell.CellType) -> FavoriteEventCell.DisplayData?
    func didTapDeleteButton(at: IndexPath)
    func didTapLikeButton(at: IndexPath)
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath)
    func countOfFavorites() -> Int
    func countOfCreated() -> Int
    func refreshView()
}
