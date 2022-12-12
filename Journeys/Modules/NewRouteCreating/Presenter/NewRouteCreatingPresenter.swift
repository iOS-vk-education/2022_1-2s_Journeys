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
    var model: NewRouteCreatingModelInput!
    weak var moduleOutput: NewRouteCreatingModuleOutput!

    let deportCellsCount: Int = 1
    let addNewCityCellsCount: Int = 1
    var arrivalCellsCount: Int = 1
    var route: Route?

    internal init(routeId: String?) {
        if let routeId = routeId {
            getRoute(routeId: routeId)
        }
        guard let route = route else {
            arrivalCellsCount = 1
            return
        }
        arrivalCellsCount = (route.places.count > 1 ? route.places.count : 1)
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
    
    private func getRoute(routeId: String) {
        model.loadRoute(with: routeId) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let route):
                strongSelf.route = route
            
            case .failure(let error):
                assertionFailure("Error while obtaining location data from server: \(error.localizedDescription)")
                strongSelf.didRecieveError(error: .obtainDataError)
            }
        }
    }
    
    func didRecieveError(error: Errors) {
        
    }
}

extension NewRouteCreatingPresenter: NewRouteCreatingModuleInput {
}

extension NewRouteCreatingPresenter: NewRouteCreatingViewOutput {
    func getDisplayData(for indexpath: IndexPath) -> NewRouteCellDisplayData {
        let displayData = NewRouteCellDisplayDataFactory()
        if indexpath.section == 0 {
            return displayData.displayData(cellType: .departureTown(location: route?.departureLocation))
        } else if indexpath.section == 1 {
            guard let route = route else {
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            guard route.places.indices.contains(indexpath.row) else {
                assertionFailure("Invalid cell row")
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            return displayData.displayData(cellType: .arrivalTown(location: route.places[indexpath.row].location))
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
        if indexPath.row == 0 {
            return nil
        }
        guard var route = route else {
            return nil
        }
        if route.places.indices.contains(indexPath.row) {
            route.places.remove(at: indexPath.row)
            arrivalCellsCount -= 1
        }
        self.route = route
        
        return deleteRow
    }

    func newRouteCreationModuleWantsToOpenAddNewLocationModule(indexPath: IndexPath) {
        guard var route = route else {
            return
        }
        if route.places.indices.contains(indexPath.row) {
            moduleOutput.newRouteCreationModuleWantsToOpenAddNewLocationModule(place: route.places[indexPath.row])
        } else {
            moduleOutput.newRouteCreationModuleWantsToOpenAddNewLocationModule(place: nil)
        }
    }
}
