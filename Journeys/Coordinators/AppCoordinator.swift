//
//  AppCoordinator.swift
//  Journeys
//
//  Created by Ищенко Анастасия on 07.11.2022.
//
import Foundation
import UIKit

class AppCoordinator: CoordinatorProtocol {

    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController
    weak var journeysCoordinatorInput: CoordinatorProtocol?
    private let firebaseService: FirebaseServiceProtocol

    init(navigationController: UINavigationController, firebaseService: FirebaseServiceProtocol) {
        self.navigationController = navigationController
        self.firebaseService = firebaseService
    }

    func start() {
        let journeysCoordinator = JourneysCoordinator(navigationController: navigationController,
                                                      firebaseService: firebaseService)
        journeysCoordinator.start()
        childCoordinators.append(journeysCoordinator)
        journeysCoordinatorInput = journeysCoordinator
    }

    // TODO: finish
    func finish() {

    }
}
