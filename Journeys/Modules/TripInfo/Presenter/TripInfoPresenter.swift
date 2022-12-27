//
//  TripInfoPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

import UIKit

// MARK: - TripInfoPresenter

final class TripInfoPresenter {
    
    // MARK: - Public Properties

    weak var view: TripInfoViewInput!
    weak var moduleOutput: TripInfoModuleOutput!
    
    private let firebaseService: FirebaseServiceProtocol
    private var firstPageIndex: Int
    
    private var trip: Trip
    private var route: Route

    internal init(firstPageMode: FirstPageMode, firebaseService: FirebaseServiceProtocol, trip: Trip, route: Route) {
        self.trip = trip
        self.route = route
        self.firstPageIndex = firstPageMode.rawValue
        self.firebaseService = firebaseService
    }
}

extension TripInfoPresenter: TripInfoModuleInput {
}

enum FirstPageMode: Int {
    case info
    case stuff
}

extension TripInfoPresenter: TripInfoViewOutput {
    func getCurrentPageIndex() -> Int {
        firstPageIndex
    }
    
    func getViewControllers() -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        let stuffVC = StuffModuleBuilder().build(output: self,
                                                 firebaseService: firebaseService,
                                                 baggageId: trip.baggageId)
        let placesInfoVC = PlacesInfoModuleBuilder().build(output: self, route: route)
        viewControllers.append(placesInfoVC)
        viewControllers.append(stuffVC)
        return viewControllers
    }
    
    func didTapEvitButton() {
        moduleOutput.tripInfoModuleWantsToClose()
    }
}

extension TripInfoPresenter: PlacesInfoModuleOutput {
    func showLoadingView() {
        moduleOutput.showLoadingView()
    }
    func hideLoadingView() {
        moduleOutput.hideLoadingView()
    }
    
    func placesModuleWantsToClose() {
        moduleOutput.tripInfoModuleWantsToClose()
    }
}

extension TripInfoPresenter: StuffModuleOutput {
    func stuffModuleWantsToClose() {
        moduleOutput.tripInfoModuleWantsToClose()
    }
}
