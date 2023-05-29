//
//  CoordinatorProtocol.swift
//  Journeys
//
//  Created by Ищенко Анастасия on 07.11.2022.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    func start()
    func finish()
}

protocol JourneysCoordinatorProtocol: CoordinatorProtocol {
    func openTripInfoModule(for tripId: String)
}

protocol AppCoordinatorProtocol: CoordinatorProtocol {
    func reload()
    func openTripInfoModule(for tripId: String)
}
