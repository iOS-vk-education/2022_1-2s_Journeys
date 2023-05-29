//
//  TripsViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation
import UIKit

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
    func moveCell(from: IndexPath, to: IndexPath)
    
    func showLoadingView()
    func hideLoadingView()
    func changeIsSavedCellStatus(at indexPath: IndexPath, status: Bool)
    
    func setupCellImage(at indexPath: IndexPath, image: UIImage)
}

// MARK: - Trips ViewOutput

protocol TripsViewOutput: AnyObject {
    var tripsType: TripsType { get }
    
    func viewWillAppear()
    func refreshView()
    
    func placeholderDisplayData() -> PlaceholderViewController.DisplayData
    func didSelectCell(at indexpath: IndexPath)
    func didTapCellBookmarkButton(at indexPath: IndexPath)
    func didTapEditButton(at indexPath: IndexPath)
    func didTapDeleteButton(at indexPath: IndexPath)
    
    func didTapBackBarButton()
    func didTapSavedBarButton()
    
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath)

    func getSectionsCount() -> Int
    func getCellsCount(for section: Int) -> Int
    func getCellType() -> TripsCellType
    func getCellData(for id: Int) -> TripCell.DisplayData?
}
