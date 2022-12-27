//
//  AccountCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.12.2022.
//

import Foundation
import UIKit
import FirebaseAuth

final class AccountCoordinator: CoordinatorProtocol {

    // MARK: Private Properties

    private let rootTabBarController: UITabBarController
    private var navigationController = UINavigationController()
    private let tabBarItemFactory: TabBarItemFactoryProtocol
    private let firebaseService: FirebaseServiceProtocol
    
    // MARK: Lifecycle

    init(rootTabBarController: UITabBarController, firebaseService: FirebaseServiceProtocol) {
        self.rootTabBarController = rootTabBarController
        self.firebaseService = firebaseService
        tabBarItemFactory = TabBarItemFactory()
    }

    // MARK: Public Methods

    // TODO: start
    func start() {
        let builder = AccountModuleBuilder()
        let accountViewController = builder.build(output: self, firebaseService: firebaseService)

        navigationController.setViewControllers([accountViewController], animated: false)

        navigationController.tabBarItem = tabBarItemFactory.getTabBarItem(from: TabBarPage.account)

        var controllers = rootTabBarController.viewControllers
        if controllers == nil {
            controllers = [navigationController]
        } else {
            controllers?.append(navigationController)
        }
        rootTabBarController.setViewControllers(controllers, animated: true)
    }

    // TODO: finish
    func finish() {
    }
}

extension AccountCoordinator: AccountModuleOutput {
    func logout() {
        Auth.auth().addIDTokenDidChangeListener { (auth, user) in
            if user == nil {
                let builder = AuthModuleBuilder()
                let viewController = builder.build(moduleType: .auth,
                                                   output: self,
                                                   firebaseService: self.firebaseService)
                self.navigationController.setViewControllers([viewController], animated: false)
            }
        }
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
    }
    
    func showLoadingView() {
        let loadingVC = LoadingViewController()
        // Animate loadingVC over the existing views on screen
        loadingVC.modalPresentationStyle = .overCurrentContext

        // Animate loadingVC with a fade in animation
        loadingVC.modalTransitionStyle = .crossDissolve
               
        navigationController.present(loadingVC, animated: true)
    }
}

extension AccountCoordinator: AuthModuleOutput {
    func authModuleWantsToChangeModulenType(currentType: AuthPresenter.ModuleType) {
        let builder = AuthModuleBuilder()
        var authViewController: UIViewController
        switch currentType {
        case .auth:
            authViewController = builder.build(moduleType: .registration,
                                               output: self,
                                               firebaseService: firebaseService)
        case .registration:
            authViewController = builder.build(moduleType: .auth,
                                               output: self,
                                               firebaseService: firebaseService)
        }
        
        navigationController.popViewController(animated: false)
        navigationController.setViewControllers([authViewController], animated: true)
    }
    
    func authModuleWantsToOpenTripsModule() {
        let builder = AccountModuleBuilder()
        let accountViewController = builder.build(output: self, firebaseService: firebaseService)

        navigationController.setViewControllers([accountViewController], animated: false)
    }
}
