//
//  NewRouteCreatingViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation
import UIKit


// MARK: - NewRouteCreating ViewInput

protocol NewRouteCreatingViewInput: AnyObject {
    func showAlert(title: String, message: String, actionTitle: String)
}

// MARK: - NewRouteCreating ViewOutput

protocol NewRouteCreatingViewOutput: AnyObject {
    func numberOfRowsInSection (section: Int) -> Int
    func didTapExitButton()
    func getDisplayData(for indexpath: IndexPath) -> NewRouteCellDisplayData
    func numberOfSectins() -> Int
    
    func didSelectRow(at indexpath: IndexPath) -> ((NewRouteCreatingViewController, UITableView)->())?
    func userWantsToDeleteCell(indexPath: IndexPath) -> ((UITableView, IndexPath) -> [UITableViewRowAction]?)?
}
