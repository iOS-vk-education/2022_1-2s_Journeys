//
//  TripsViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation

// MARK: - Trips ViewInput

protocol TripsViewInput: AnyObject {
    func showAlert(title: String, message: String, actionTitle: String)
    func showChoiceAlert(title: String,
                         message: String,
                         agreeActionTitle: String,
                         disagreeActionTitle: String,
                         cellIndexPath: IndexPath)
    func reloadData()
    func endRefresh()
    func deleteItem(at indexPath: IndexPath)
    func showLoadingView()
    func hideLoadingView()
    func changeIsSavedCellStatus(at indexPath: IndexPath, status: Bool)
}

// MARK: - Trips ViewOutput

protocol TripsViewOutput: AnyObject {
    func viewDidLoad()
    func refreshView()
    
    func placeholderDisplayData() -> PlaceHolderViewController.DisplayData
    func getScreenType() -> TripsViewController.ScreenType
    func didSelectCell(at indexpath: IndexPath)
    func didTapCellBookmarkButton(at indexPath: IndexPath)
    func didTapEditButton(at indexPath: IndexPath)
    func didTapDeleteButton(at indexPath: IndexPath)
    
    func didTapBackBarButton()
    func didTapSavedBarButton()
    
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath)

    func getSectionsCount() -> Int
    func getCellsCount(for section: Int) -> Int
    func getCellData(for id: Int) -> TripCell.DisplayData?
}
