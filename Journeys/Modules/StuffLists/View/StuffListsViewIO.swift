//
//  StuffListsViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import Foundation


// MARK: - StuffLists ViewInput

protocol StuffListsViewInput: AnyObject {
    func reloadData()
    
    func showNewStuffListButton()
    func setCheckmarkVisibility(to value: Bool, at indexPath: IndexPath)
    
    func setCollectionViewAllowsSelection(to value: Bool)
    
    func embedPlaceholder()
    func hidePlaceholder()
    
    func showAlert(title: String, message: String)
}

// MARK: - StuffLists ViewOutput

protocol StuffListsViewOutput: AnyObject {
    func viewWillAppear()
    func didTapBackBarButton()
    func didSelectCell(at indexPath: IndexPath)
    func cellsCount(for section: Int) -> Int
    func cellData(for indexPath: IndexPath) -> StuffListCell.Displaydata?
    
    func didTapNewStuffListButton()
}
