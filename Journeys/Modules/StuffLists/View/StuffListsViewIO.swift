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
    
    func embedPlaceholder()
    func hidePlaceholder()
}

// MARK: - StuffLists ViewOutput

protocol StuffListsViewOutput: AnyObject {
    func viewDidAppear()
    func didTapBackBarButton()
    func didSelectCell(at indexPath: IndexPath)
    func cellsCount(for section: Int) -> Int
    func cellData(for indexPath: IndexPath) -> StuffListCell.Displaydata?
    
    func didTapNewStuffListButton()
}
