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
    func currencyAmountString(at indexPath: IndexPath,
                              viewType: CurrencyView.ViewType) -> String?
    func endRefresh()
    
    func showPickerView(touch: UITapGestureRecognizer, with selectedCurrencyIndex: Int)
    func hidePickerView()
    func updateCurrencyCell(at indexPath: IndexPath,
                            displayData: CurrencyCell.DisplayData,
                            localCurrencyAmount: String?)
}

// MARK: - PlacesIngo ViewOutput

protocol PlacesInfoViewOutput: AnyObject {
    func viewDidLoad()
    func refreshView()
    
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
    
    func pickerViewTitle(for row: Int) -> String?
    func pickerViewRowsCount() -> Int
    func didSelectNewCurrency(at row: Int)
}
