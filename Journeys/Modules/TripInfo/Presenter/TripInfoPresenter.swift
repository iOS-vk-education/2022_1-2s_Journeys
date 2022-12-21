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
    
    private var routeId: String
    private var firstPageIndex: Int

    internal init(firstPageMode: FirstPageMode, routeId: String) {
        self.routeId = routeId
        self.firstPageIndex = firstPageMode.rawValue
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
        let stuffVC = StuffModuleBuilder().build(output: self)
        let placesInfoVC = PlacesInfoModuleBuilder().build(output: self, routeId: routeId)
        viewControllers.append(placesInfoVC)
        viewControllers.append(stuffVC)
        return viewControllers
    }
    
}

extension TripInfoPresenter: PlacesInfoModuleOutput {
    func placesModuleWantsToClose() {
        moduleOutput.tripInfoModuleWantsToClose()
    }
}

extension TripInfoPresenter: StuffModuleOutput {
    func stuffModuleWantsToClose() {
        moduleOutput.tripInfoModuleWantsToClose()
    }
}
