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
}

// MARK: - Stuff ViewOutput

protocol StuffViewOutput: AnyObject {
    func viewDidLoad()
    func didSelectRow(at indexPath: IndexPath, rowsInSection: Int) -> ((StuffViewController, UITableView, Int)->())?
//    func didSelectRow(row: Int, rowsInSection: Int)
    func getNumberOfRows(in section: Int) -> Int
    func getStuffCellDisplayData(for indexpath: IndexPath) -> StuffCell.DisplayData?
    
//    func didTapCellPackButton(at indexpath: IndexPath) -> ((StuffViewController) -> ())?
    func didTapCellPackButton(at indexpath: IndexPath?, tableView: UITableView)
}
