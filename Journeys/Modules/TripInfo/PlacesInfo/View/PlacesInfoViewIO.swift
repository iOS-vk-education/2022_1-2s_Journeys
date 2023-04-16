//
//  PlacesIngoViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//
import Foundation
import UIKit

// MARK: - PlacesIngo ViewInput

protocol PlacesInfoViewInput: AnyObject {
    func reloadData()
    func showAlert(title: String, message: String)
    func showLoadingView()
    func hideLoadingView()
    func changeCurrencyTextField(at indexPath: IndexPath,
                                 viewType: CurrencyView.ViewType,
                                 to text: String)
}

// MARK: - PlacesIngo ViewOutput

protocol PlacesInfoViewOutput: AnyObject {
    func viewDidLoad()

    func sectionsCount() -> Int
    func mainCollectionCellsCount(for section: Int) -> Int
    func weatherCollectionCellsCount(for collectionIndexPath: IndexPath) -> Int
    func mainCollectionCellType(for indexPath: IndexPath) -> PlacesInfoPresenter.CellType?
    
    func routeCellDisplayData() -> ShortRouteCell.DisplayData?
    func weatherCollectionDisplayData(_ row: Int) -> WeatherCollection.DisplayData?
    func currencyCellDisplayData(for indexPath: IndexPath) -> CurrencyCell.DisplayData?
    func eventCellDisplayData(for indexPath: IndexPath) -> EventMapCell.DisplayData?
    
    func weatherCollectionCellDisplayData(collectionRow: Int, cellRow: Int) -> WeatherCell.DisplayData?

    func headerText(for indexPath: IndexPath) -> String

    func didSelectItem(at indexPath: IndexPath)
    
    func didTapExitButton()
}
