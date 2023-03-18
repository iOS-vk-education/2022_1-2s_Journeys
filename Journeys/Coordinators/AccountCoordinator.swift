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
import MessageUI

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
        let accountViewController = builder.build(firebaseService: firebaseService, moduleOutput: self)

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
    func accountModuleWantsToOpenAccountInfoModule() {
        let builder = AccountInfoModuleBuilder()
        let accountInfoViewController = builder.build(output: self, firebaseService: firebaseService)
        navigationController.pushViewController(accountInfoViewController, animated: true)
    }
    
    // TODO: accountModuleWantsToOpenStuffListsModule
    func accountModuleWantsToOpenStuffListsModule() {
        print("Open StuffLists module")
    }
    
    func accountModuleWantsToOpenSettingsModule() {
        let builder = SettingsModuleBuilder()
        let settingsViewController = builder.build(moduleOutput: self)
        navigationController.pushViewController(settingsViewController, animated: true)
    }
    
    
}

extension AccountCoordinator: SettingsModuleOutput {
    func settingsModuleWantsToBeClosed() {
        self.navigationController.popViewController(animated: true)
    }
    
    func settingsModuleWantsToOpenSettingsSubModule(type: SettingsViewType, animated: Bool) {
        let settingsViewModel = SettingsViewModel(viewType: type)
        let settingsView = SettingsView(viewModel: settingsViewModel)
        let hosting = UIHostingController(rootView: settingsView)
        hosting.view.backgroundColor = .clear
        hosting.navigationItem.title = type.localized
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController.pushViewController(hosting, animated: animated)
    }
}

extension AccountCoordinator: AccountInfoModuleOutput {
    func accountInfoModuleWantToBeClosed() {
        self.navigationController.popViewController(animated: true)
    }
    
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
        loadingVC.modalPresentationStyle = .overCurrentContext
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
        let builder = AccountInfoModuleBuilder()
        let accountInfoViewController = builder.build(output: self, firebaseService: firebaseService)

        navigationController.setViewControllers([accountInfoViewController], animated: false)
    }
}
