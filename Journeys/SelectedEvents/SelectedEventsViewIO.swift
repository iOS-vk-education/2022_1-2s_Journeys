//
//  SelectedEventsViewIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation
import UIKit

// MARK: - Events ViewInput
protocol SelectedEventsViewInput: AnyObject {
    func reloadFavorites()
    func reloadCreated()
    func show(error: Error)
    func reloadImage()
    func showChoiceAlert(title: String,
                         message: String,
                         agreeActionTitle: String,
                         disagreeActionTitle: String,
                         cellIndexPath: IndexPath)
    func endRefresh()
    func setupCreatedCellImage(at indexPath: IndexPath, image: UIImage)
    func setupFavoriteCellImage(at indexPath: IndexPath, image: UIImage)
}

// MARK: - Events ViewOutput
protocol SelectedEventsViewOutput: AnyObject {
    func didTapCloseButton()
    func didLoadView()
    func displayingCreatedEvent(for row: Int, cellType: FavoriteEventCell.CellType) -> FavoriteEventCell.DisplayData?
    func didTapDeleteButton(at: IndexPath)
    func didTapLikeButton(at: IndexPath)
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath)
    func countOfFavorites() -> Int
    func countOfCreated() -> Int
    func refreshView()
    func didTapFavoriteCell(at: IndexPath)
    func didTapCreatedCell(at: IndexPath)
    func didTapScreen()
    func didTapEditingButton(at: IndexPath)
}
