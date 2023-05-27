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

    init(rootTabBarController: UITabBarController,
         firebaseService: FirebaseServiceProtocol) {
        self.rootTabBarController = rootTabBarController
        self.firebaseService = firebaseService
        tabBarItemFactory = TabBarItemFactory()
    }

    // MARK: Public Methods

    // TODO: start
    func start() {
        authListener()
        
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
    
    private func authListener() {
        Auth.auth().addIDTokenDidChangeListener { [weak self] (auth, user) in
            guard let self else { return }
            if user == nil {
                let builder = AuthModuleBuilder()
                let viewController = builder.build(moduleType: .auth,
                                                   output: self,
                                                   firebaseService: self.firebaseService)
                viewController.isModalInPresentation = true
                self.navigationController.present(viewController, animated: true)
            }
        }
    }
}

extension AccountCoordinator: AccountModuleOutput {
    func accountModuleWantsToOpenAccountInfoModule(with userData: User?) {
        let builder = AccountInfoModuleBuilder()
        let accountInfoViewController = builder.build(output: self,
                                                      firebaseService: firebaseService, 
                                                      userData: userData)
        navigationController.pushViewController(accountInfoViewController, animated: true)
    }
    
    // TODO: accountModuleWantsToOpenStuffListsModule
    func accountModuleWantsToOpenStuffListsModule() {
        let builder = StuffListsModuleBuilder()
        let stuffListsViewController = builder.build(firebaseService: firebaseService,
                                                     moduleOutput: self)
        navigationController.pushViewController(stuffListsViewController, animated: true)
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
        navigationController.popViewController(animated: true)
    }
}

extension AccountCoordinator: StuffListsModuleOutput {
    func closeStuffListsModule() {
        navigationController.popViewController(animated: true)
    }
    
    func openCertainStuffListModule(for stuffList: StuffList?) {
        let builder = CertainStuffListModuleBuilder()
        let certainStuffListViewController = builder.build(stuffList: stuffList,
                                                           firebaseService: firebaseService,
                                                           moduleOutput: self)
        navigationController.pushViewController(certainStuffListViewController, animated: true)
    }
}

extension AccountCoordinator: CertainStuffListModuleOutput {
    func closeCertainStuffListsModule() {
        if let _ = navigationController.viewControllers.last as? CertainStuffListViewController {
            navigationController.popViewController(animated: true)
        }
    }
}

extension AccountCoordinator: AuthModuleOutput {
    func authModuleWantsToBeClosed() {
        navigationController.dismiss(animated: true)
        guard let accountInfoView = navigationController.viewControllers.last as? AccountInfoViewController
        else { return }
        accountInfoView.reload()
    }
}
