//
//  StuffViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

import UIKit
import Foundation


// MARK: - Stuff ViewInput

protocol StuffViewInput: AnyObject {
    func reloadData()
    func showAlert(title: String, message: String)
    func endRefresh()
    
    func moveTableViewRow(at fromIndexPath: IndexPath, to toIndexPath: IndexPath)
    func getCellsData(from indexPath: IndexPath) -> StuffCell.StuffData?
    func changeIsPickedCellFlag(at indexPath: IndexPath)
    
    func getCell(for indexpath: IndexPath) -> UITableViewCell?
    func deleteCell(at indexPath: IndexPath)
    
    func setCellIndexPath(_ indexPath: IndexPath)
    
    func refreshAllCellsIndexPaths()
}

// MARK: - Stuff ViewOutput

protocol StuffViewOutput: AnyObject {
    func viewDidLoad()
    func didTapAddStuffListButton()
    func didTapScreen(tableView: UITableView)
    func didTapExitButton()
    func didChangeBaggage()
}
