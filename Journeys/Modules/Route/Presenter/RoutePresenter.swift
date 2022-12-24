//
//  RoutePresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation
import UIKit

// MARK: - RoutePresenter

final class RoutePresenter {

    // MARK: - Public Properties

    weak var view: RouteViewInput!
    var model: RouteModelInput!
    weak var moduleOutput: RouteModuleOutput!

    let deportCellsCount: Int = 1
    let addNewCityCellsCount: Int = 1
    var arrivalCellsCount: Int = 0
    
    var route: Route?
    var trip: Trip?

    internal init(trip: Trip?) {
        self.trip = trip
    }
    
    private let addNewCellClosure: (RouteViewController, UITableView)->() = { view, tableView in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell") as? RouteCell
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

extension RoutePresenter: RouteViewOutput {
    func viewDidLoad() {
        guard let trip = trip else { return }
        getRoute(routeId: trip.routeId)
    }
    
    
    func numberOfSectins() -> Int {
        3
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
    
    func getDisplayData(for indexpath: IndexPath) -> RouteCell.DisplayData {
        let displayData = RouteCellDisplayDataFactory()
        if indexpath.section == 0 {
            return displayData.displayData(cellType: .departureTown(location: route?.departureLocation))
        } else if indexpath.section == 1 {
            guard let route = route else {
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            guard route.places.indices.contains(indexpath.row) else {
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            return displayData.displayData(cellType: .arrivalTown(location: route.places[indexpath.row].location))
        } else {
            return displayData.displayData(cellType: .newLocation)
        }
    }

    func didTapExitButton() {
        moduleOutput.routeModuleWantsToClose()
    }
    
    func didTapFloatingSaveButton() {
        guard let route = route else {
            view.showAlert(title: "Ошибка", message: "Ошибка сохранения данных")
            return
        }
        if trip == nil {
            model.storeNewTrip(route: route)
        } else {
            model.storeRouteData(route: route)
        }
    }
    
    func didSelectRow(at indexpath: IndexPath) -> ((RouteViewController, UITableView)->())? {
        switch indexpath.section {
        case 0:
            routeModuleWantsToOpenDepartureLocationModule()
            return nil
        case 1:
            routeModuleWantsToOpenPlacenModule(indexPath: indexpath)
            return nil
        case 2:
            guard route != nil else {
                view.showAlert(title: "Введите город отправления", message: "Сначала введите город отправления")
                return nil
            }
            arrivalCellsCount += 1
            return addNewCellClosure
        default:
            assertionFailure("Cell selection error: too much sections")
            return nil
        }
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
}

extension RoutePresenter: RouteModelOutput {
    func didFetchRouteData(data: Route) {
        self.route = data
        arrivalCellsCount = (data.places.count > 1 ? data.places.count : 1)
        view.reloadData()
    }
    func didRecieveError(error: Errors) {
        switch error {
        case .obtainDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при получении данных")
        case .saveDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при сохранении данных")
        case .deleteDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при удалении данных")
        }
    }
    
    func didSaveRouteData() {
    }
}

extension RoutePresenter: RouteModuleInput {
    func updateRouteDepartureLocation(location: Location) {
        if self.route != nil {
            self.route!.departureLocation = location
        } else {
            self.route = Route(id: nil, departureLocation: location, places: [])
            self.arrivalCellsCount += 1
        }
        view.reloadData()
    }
    func updateRoutePlaces(place: Place, placeIndex: Int) {
        if route?.places.indices.contains(placeIndex) == true {
            self.route?.places[placeIndex] = place
        } else {
            self.route?.places.append(place)
        }
        view.reloadData()
    }
}

extension RoutePresenter: StoreNewTripOutput {
    func saveFinished() {
        return
    }
    
    func saveError() {
        didRecieveError(error: .saveDataError)
    }
}


private extension RoutePresenter {
    func getRoute(routeId: String) {
        model.obtainRouteDataFromSever(with: routeId)
    }
    
    func routeModuleWantsToOpenPlacenModule(indexPath: IndexPath) {
        guard let route = route else {
            moduleOutput.routeModuleWantsToOpenPlaceModule(place: nil,
                                                           placeIndex: indexPath.row,
                                                           routeModuleInput: self)
            return
        }
        if route.places.indices.contains(indexPath.row) {
            moduleOutput.routeModuleWantsToOpenPlaceModule(place: route.places[indexPath.row],
                                                           placeIndex: indexPath.row,
                                                           routeModuleInput: self)
        } else {
            moduleOutput.routeModuleWantsToOpenPlaceModule(place: nil,
                                                           placeIndex: indexPath.row,
                                                           routeModuleInput: self)
        }
    }
    
    func sortRoutePlaces() {
        route?.places.sort(by: {$0.depart.timeIntervalSinceNow > $1.depart.timeIntervalSinceNow})
    }
    
    func routeModuleWantsToOpenDepartureLocationModule() {
        moduleOutput.routeModuleWantsToOpenDepartureLocationModule(departureLocation: route?.departureLocation,
                                                                   routeModuleInput: self)
    }
}
