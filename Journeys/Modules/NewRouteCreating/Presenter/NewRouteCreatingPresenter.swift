//
//  NewRouteCreatingPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation
import UIKit

// MARK: - NewRouteCreatingPresenter

final class NewRouteCreatingPresenter {

    // MARK: - Public Properties

    weak var view: NewRouteCreatingViewInput!
    weak var moduleOutput: NewRouteCreatingModuleOutput!
    let model: NewRouteCreatingModel

    let deportCellsCount: Int = 1
    let addNewCityCellsCount: Int = 1
    var arrivalCellsCount: Int = 1
    var departureLocation: Location? = nil
    var places: [Place] = []

    internal init() {
//        places = plases2
        arrivalCellsCount = (places.count > 1 ? places.count : 1)
        model = NewRouteCreatingModel()
    }

    private let addNewCellClosure: (NewRouteCreatingViewController, UITableView)->() = { view, tableView in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewRouteCell") as? NewRouteCell
        else {
            assertionFailure("Error while creating cell")
            return
        }
        let indexPath = NSIndexPath(row: tableView.numberOfRows(inSection: 1), section: 1)
        cell.configure(displayData: view.output.getDisplayData(for: indexPath as IndexPath))
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    private let deleteRow: (UITableView, IndexPath) -> [UITableViewRowAction]? = { tableView, indexPath in
        let deleteAction = UITableViewRowAction(style: .destructive, title: L10n.delete) { (action, indexPath) in
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        return[deleteAction]
    }
}

extension NewRouteCreatingPresenter: NewRouteCreatingModuleInput {
}

extension NewRouteCreatingPresenter: NewRouteCreatingViewOutput {
    func getDisplayData(for indexpath: IndexPath) -> NewRouteCellDisplayData {
        let displayData = NewRouteCellDisplayDataFactory()
        if indexpath.section == 0 {
            return displayData.displayData(cellType: .departureTown(location: departureLocation))
        } else if indexpath.section == 1 {
            guard places.indices.contains(indexpath.row) else {
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            return displayData.displayData(cellType: .arrivalTown(location: places[indexpath.row].location))
        } else {
            return displayData.displayData(cellType: .newLocation)
        }
    }
    
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return deportCellsCount
        case 1:
            return arrivalCellsCount
        case 2:
            return addNewCityCellsCount
        default:
            return 0
        }
    }
    
    func didTapExitButton() {
        moduleOutput.newRouteCreationModuleWantsToClose()
    }
    
    func numberOfSectins() -> Int {
        3
    }
    
    func didSelectRow(at indexpath: IndexPath) -> ((NewRouteCreatingViewController, UITableView)->())? {
        if indexpath.section < 2 {
            newRouteCreationModuleWantsToOpenAddNewLocationModule(indexPath: indexpath)
        } else if indexpath.section == 2 {
            arrivalCellsCount += 1
            return addNewCellClosure
        } else {
            assertionFailure("Cell selection error: too much sections")
        }
        return nil
    }
    
    func userWantsToDeleteCell(indexPath: IndexPath) -> ((UITableView, IndexPath) -> [UITableViewRowAction]?)? {
        if indexPath.section != 1 || indexPath.row == 0 {
            return nil
        }
        arrivalCellsCount -= 1
        if places.indices.contains(indexPath.row) {
            places.remove(at: indexPath.row)
        }
        return deleteRow
    }
    
    func newRouteCreationModuleWantsToOpenAddNewLocationModule(indexPath: IndexPath) {
        if places.indices.contains(indexPath.row) {
            moduleOutput.newRouteCreationModuleWantsToOpenAddNewLocationModule(place: places[indexPath.row])
        } else {
            moduleOutput.newRouteCreationModuleWantsToOpenAddNewLocationModule(place: nil)
        }
    }
}
