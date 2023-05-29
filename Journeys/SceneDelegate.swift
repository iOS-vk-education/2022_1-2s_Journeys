//
//  SceneDelegate.swift
//  Journeys
//
//  Created by Сергей Адольевич on 02.11.2022.
//

import UIKit

let themeWindow = ThemeWindow()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinatorProtocol?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        NotificationsManager.shared.notificationCenter.delegate = self
        
        window = UIWindow(windowScene: scene)
        window?.initTheme()
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([], animated: false)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let firebaseService = FirebaseService()
        coordinator = AppCoordinator(tabBarController: tabBarController, firebaseService: firebaseService)
        
        coordinator?.start()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .banner])
    }
}

extension Theme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return themeWindow.traitCollection.userInterfaceStyle
        }
    }

    func setActive() {
        // Сохраняем активную тему
        save()

        // Устанавливаем активную тему для всех окон приложения
        // Не красим это окно чтобы узнавать системную тему
        UIApplication.shared.windows
            .filter { $0 != themeWindow }
            .forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }
    }
}
