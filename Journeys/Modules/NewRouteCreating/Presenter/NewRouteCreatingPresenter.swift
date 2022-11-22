//
//  NewRouteCreatingPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation
import UIKit

struct Location {
    var country: String
    var city: String
}

// MARK: - NewRouteCreatingPresenter

final class NewRouteCreatingPresenter {
    
    
    // MARK: - Public Properties

    weak var view: NewRouteCreatingViewInput!
    weak var moduleOutput: NewRouteCreatingModuleOutput!
    let model: NewRouteCreatingModel
    let deportCellsCount: Int = 1
    let addNewCityCellsCount: Int = 1
    var arrivalCellsCount: Int = 1
    var arrivalLocation: Location? = nil
    var locations: [Location?] = []
    
    internal init() {
        let countries = ["Russia"]
        let cities = ["Moscow"]
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        locations.append(Location(country: countries[0], city: cities[0]))
        arrivalCellsCount = (locations.count > 1 ? locations.count : 1)
        model = NewRouteCreatingModel()
    }
    
    private let addNewCellClosure: (NewRouteCreatingViewController, UITableView)->() = { view, tableView in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewRouteCell") as? NewRouteCell
        else {
            assertionFailure("Error while creating cell")
            return
        }
        let indexPath = NSIndexPath(row: tableView.numberOfRows(inSection: 1), section: 1)
        cell.configure(displayData: NewRouteCellDisplayDataFactory().displayData(cellType: view.output.giveCellType(for: indexPath as IndexPath)))
        
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
    
    func giveCellType(for indexpath: IndexPath) -> NewRouteCellType {
        
        var type: NewRouteCellType
        if indexpath.section == 0 {
            return .departureTown(location: arrivalLocation)
        } else if indexpath.section == 1 {
            guard locations.indices.contains(indexpath.row) else {
                return .arrivalTown(location: nil)
            }
            return .arrivalTown(location: locations[indexpath.row])
        } else {
            type = .newLocation
        }
        return type
    }
    
    func numberOfSectins() -> Int {
        3
    }
    
    func didSelectRow(at indexpath: IndexPath) -> ((NewRouteCreatingViewController, UITableView)->())? {
        if indexpath.section < 2 {
            openTownAddingModule()
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
        if locations.indices.contains(indexPath.row) {
            locations.remove(at: indexPath.row)
        }
        return deleteRow
    }
    
    private func openTownAddingModule() {
        
    }
}
