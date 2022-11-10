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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let journeysCoordinator = JourneysCoordinator(navigationController: navigationController)
        journeysCoordinator.start()
        childCoordinators.append(journeysCoordinator)
        journeysCoordinatorInput = journeysCoordinator
    }
    
    // TODO: finish
    func finish() {
        
    }
}
