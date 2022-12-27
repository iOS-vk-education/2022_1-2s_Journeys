//
//  AppDelegate.swift
//  Journeys
//
//  Created by Ищенко Анастасия on 30.10.2022.
//

import UIKit
import YandexMapsMobile
import FirebaseCore
import FirebaseAuth

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        YMKMapKit.setApiKey("d594da49-3ffb-4815-acc6-61baf9f12f54")
        YMKMapKit.sharedInstance()

        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
