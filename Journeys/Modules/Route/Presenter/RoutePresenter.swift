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
    var trip: TripWithRouteAndImage?
    var tripImage: UIImage?

    internal init(trip: TripWithRouteAndImage?) {
        self.trip = trip
        guard let trip = trip else { return }
        route = trip.route
        arrivalCellsCount = route?.places.count ?? 0
        tripImage = trip.image
    }
    
    private let addNewCellClosure: (RouteViewController, UITableView)->() = { view, tableView in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell") as? RouteCell
        else {
            return
        }
        let indexPath = NSIndexPath(row: tableView.numberOfRows(inSection: 2), section: 2)
        guard let displayData = view.output.getDisplayData(for: indexPath as IndexPath) else { return }
        cell.configure(displayData: displayData)
        
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
    
    private func showLoadingView() {
        view.showLoadingView()
    }
    private func hideLoadingView() {
        view.hideLoadingView()
    }
    
    private func showAlert(error: Errors) {
        guard let alertShowingVC = view as? AlertShowingViewController else { return }
        askToShowErrorAlert(error, alertShowingVC: alertShowingVC)
    }
}

extension RoutePresenter: RouteViewOutput {
    
    func viewDidLoad() {
        guard let trip = trip else { return }
    }
    
    func numberOfSectins() -> Int {
        4
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return deportCellsCount
        case 2:
            return arrivalCellsCount
        case 3:
            return addNewCityCellsCount
        default:
            return 0
        }
    }
    
    func getImageCellDisplayData() -> UIImage {
        if let tripImage = tripImage {
            return tripImage
        }
        let numberOfImages = 5
        let random = Int.random(in: 1...numberOfImages)
        let image = UIImage(named: "TripCellImage\(random)")
        tripImage = image
        return image ?? UIImage()
    }
    
    func getDisplayData(for indexpath: IndexPath) -> RouteCell.DisplayData? {
        let displayData = RouteCellDisplayDataFactory()
        switch indexpath.section {
        case 1:
            return displayData.displayData(cellType: .departureTown(location: route?.departureLocation))
        case 2:
            guard let route = route else {
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            guard route.places.indices.contains(indexpath.row) else {
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            return displayData.displayData(cellType: .arrivalTown(location: route.places[indexpath.row].location))
        case 3:
            return displayData.displayData(cellType: .newLocation)
        default:
            return nil
        }
    }

    func didTapExitButton() {
        moduleOutput.routeModuleWantsToClose()
    }
    
    func didTapFloatingSaveButton() {
        guard var route = route else {
            showAlert(error: .custom(title: nil, message:  L10n.Alerts.Messages.Route.enterDepartureTown))
            return
        }
        guard let tripImage = tripImage else {
            showAlert(error: .custom(title: nil, message:  L10n.Alerts.Messages.Route.addTripPhoto))
            return
        }
        guard let trip = trip,
              let tripId = trip.id else {
            showLoadingView()
            model.storeNewTrip(route: route, tripImage: tripImage)
            return
        }
        showLoadingView()
        
        if route.id != nil {
            for index in 0..<route.places.count {
                if !route.places[index].allowNotification,
                    let notification = route.places[index].notification,
                    notification.id != nil {
                    model.deleteNotification(notification)
                    route.places[index].notification = nil
                }
            }
        }
        self.route = route
        model.saveNotifications(for: route) { [weak self] newRoute in
            self?.route = newRoute
            self?.model.storeRouteData(route: newRoute, tripImage: tripImage, tripId: tripId)
        }
    }
    
    func didSelectRow(at indexpath: IndexPath) -> ((RouteViewController, UITableView)->())? {
        switch indexpath.section {
        case 0:
            view.showImagePicker()
            return nil
        case 1:
            routeModuleWantsToOpenDepartureLocationModule()
            return nil
        case 2:
            routeModuleWantsToOpenPlacenModule(indexPath: indexpath)
            return nil
        case 3:
            guard route != nil else {
                showAlert(error: .custom(title: nil, message: L10n.Alerts.Messages.Route.enterDepartureTown))
                return nil
            }
            arrivalCellsCount += 1
            return addNewCellClosure
        default:
            return nil
        }
    }

    func userWantsToDeleteCell(indexPath: IndexPath) -> ((UITableView, IndexPath) -> [UITableViewRowAction]?)? {
        if indexPath.section != 2 || (route?.places.count == 0 && indexPath.row == 0) {
            return nil
        }
        guard var route = route else {
            return nil
        }
        arrivalCellsCount -= 1
        if route.places.count > indexPath.row {
            route.places.remove(at: indexPath.row)
        }
        self.route = route
        return deleteRow
    }
    
    func setTripImage(_ image: UIImage) {
        self.tripImage = image
    }
}

extension RoutePresenter: RouteModelOutput {
    func didRecieveError(error: Errors) {
        hideLoadingView()
        showAlert(error: error)
    }
    
    func didSaveRouteData(route: Route) {
        guard let trip else {
            hideLoadingView()
            showAlert(error: .obtainDataError)
            return
        }
        moduleOutput.routeModuleWantsToOpenTripInfoModule(trip: Trip(tripWithOtherData: trip),
                                                          route: route)
        hideLoadingView()
    }
    
    func didSaveData(trip: Trip, route: Route) {
        moduleOutput.routeModuleWantsToOpenTripInfoModule(trip: trip,
                                                          route: route)
        hideLoadingView()
    }
    
    func notificationDateMustBeFutureError() {
        showAlert(error: .custom(title: "Future date", message: "Error"))
    }
}

extension RoutePresenter: RouteModuleInput {
    func getTripId() -> String? {
        trip?.id
    }
    
    func updateRouteDepartureLocation(location: Location) {
        if self.route != nil {
            self.route!.departureLocation = location
        } else {
            self.route = Route(id: nil, imageURLString: nil, departureLocation: location, places: [])
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


private extension RoutePresenter {
    
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
    
    func routeModuleWantsToOpenDepartureLocationModule() {
        moduleOutput.routeModuleWantsToOpenDepartureLocationModule(departureLocation: route?.departureLocation,
                                                                   routeModuleInput: self)
    }
}

extension RoutePresenter: AskToShowAlertProtocol {
}
