//
//  TabbarItemFactory.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.12.2022.
//

import Foundation
import UIKit

// MARK: - TabBarItemFactoryProtocol

protocol TabBarItemFactoryProtocol {
    func getTabBarItem(from page: TabBarPage) -> UITabBarItem
}

// MARK: - TabBarItemFactory

final class TabBarItemFactory: TabBarItemFactoryProtocol {
    func getTabBarItem(from page: TabBarPage) -> UITabBarItem {
        UITabBarItem(title: page.pageTitle,
                     image: UIImage(systemName: page.pageIconName),
                     tag: page.numberOfPage)
    }
}
