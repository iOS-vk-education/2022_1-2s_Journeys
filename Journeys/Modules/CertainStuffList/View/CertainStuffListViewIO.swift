//
//  CertainStuffListViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import UIKit
import Foundation

// MARK: - CertainStuffList ViewInput

protocol CertainStuffListViewInput: AnyObject {
    func reloadData()
    func showColorPicker(selectedColor: UIColor)
    func changeStuffListCellColoredViewColor(to color: UIColor, at indexPath: IndexPath)
    func tableViewBackgroundColor() -> UIColor?
    
    func getCollectionCellData(for indexPath: IndexPath) -> StuffListCell.StuffListData?
    func getTableCell(for indexpath: IndexPath) -> UITableViewCell?
    func getTableCellsData(from indexPath: IndexPath) -> StuffCell.StuffData?
    
    func showAlert(title: String, message: String)
    func deleteCell(at indexPath: IndexPath)
    
    func setTapGestureRecognizerEnabled(_ value: Bool)
}

// MARK: - CertainStuffList ViewOutput

protocol CertainStuffListViewOutput: AnyObject {
    func viewDidLoad()
    func didTapBackBarButton()
    func cellData(for indexPath: IndexPath) -> StuffListCell.Displaydata?
    
    func didPickColor(color: UIColor)
    func didTapScreen(tableView: UITableView)
    
    func didTapSaveButton()
    func didTapTrashButton()
    
    func editingCellIndexPath() -> IndexPath?
}
