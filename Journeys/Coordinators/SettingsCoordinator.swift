//
//  AccountCoordinator.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.12.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import SwiftUI

final class SettingsCoordinator: CoordinatorProtocol {

    // MARK: Private Properties

    private let rootTabBarController: UITabBarController
    private var rootNavigationController = UINavigationController()
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
        let builder = SettingsModuleBuilder()
        let settingsViewController = builder.build(firebaseService: firebaseService, moduleOutput: self)

        rootNavigationController.setViewControllers([settingsViewController], animated: false)

        rootNavigationController.tabBarItem = tabBarItemFactory.getTabBarItem(from: TabBarPage.settings)

        var controllers = rootTabBarController.viewControllers
        if controllers == nil {
            controllers = [rootNavigationController]
        } else {
            controllers?.append(rootNavigationController)
        }
        rootTabBarController.setViewControllers(controllers, animated: true)
    }

    // TODO: finish
    func finish() {
    }
}

extension SettingsCoordinator: SettingsModuleOutput {
    func settingsModuleWantsToOpenSettingsSubModule(type: SettingsViewType, animated: Bool) {
        let settingsViewModel = SettingsViewModel(viewType: type)
        let settingsView = SettingsView(viewModel: settingsViewModel)
        let hosting = UIHostingController(rootView: settingsView)
        hosting.view.backgroundColor = .clear
        hosting.navigationItem.title = type.localized
        let backButton = UIBarButtonItem()
        backButton.title = ""
        rootNavigationController.navigationBar.topItem?.backBarButtonItem = backButton
//        rootNavigationController.navigationBar.tintColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        rootNavigationController.pushViewController(hosting, animated: animated)
    }
}

extension SettingsCoordinator: AccountModuleOutput {
    func logout() {
        Auth.auth().addIDTokenDidChangeListener { (auth, user) in
            if user == nil {
                let builder = AuthModuleBuilder()
                let viewController = builder.build(moduleType: .auth,
                                                   output: self,
                                                   firebaseService: self.firebaseService)
                self.rootNavigationController.setViewControllers([viewController], animated: false)
            }
        }
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.rootNavigationController.dismiss(animated: true)
        }
    }
    
    func showLoadingView() {
        let loadingVC = LoadingViewController()
        // Animate loadingVC over the existing views on screen
        loadingVC.modalPresentationStyle = .overCurrentContext

        // Animate loadingVC with a fade in animation
        loadingVC.modalTransitionStyle = .crossDissolve
               
        rootNavigationController.present(loadingVC, animated: true)
    }
}

extension SettingsCoordinator: AuthModuleOutput {
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
        
        rootNavigationController.popViewController(animated: false)
        rootNavigationController.setViewControllers([authViewController], animated: true)
    }
    
    func authModuleWantsToOpenTripsModule() {
        let builder = AccountModuleBuilder()
        let accountViewController = builder.build(output: self, firebaseService: firebaseService)

        rootNavigationController.setViewControllers([accountViewController], animated: false)
    }
}
