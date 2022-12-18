//
//  StuffPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

import Foundation
import UIKit

// MARK: - StuffPresenter

final class StuffPresenter {
    // MARK: - Public Properties

    weak var view: StuffViewInput!
    private var stuff: [String] = []

    
}

extension StuffPresenter: StuffModuleInput {
}

extension StuffPresenter: StuffViewOutput {
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
}
