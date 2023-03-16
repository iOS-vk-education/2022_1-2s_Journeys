//
//  NotificationManager.swift
//  Journeys
//
//  Created by Сергей Адольевич on 09.03.2023.
//

import Foundation
import UserNotifications
import UIKit

// MARK: - NotificationsManagerProtocol

protocol NotificationsManagerProtocol {
    func hasUserEnabledNotifications(completion: @escaping (Bool) -> Void)
    func toggleNotifications(isOn: Bool, completion: @escaping (Bool) -> Void)
    func hasUserEnabledNotificationsAtIOSLevel(completion: @escaping (Bool) -> Void)
}

// MARK: - NotificationsManager

final class NotificationsManager: NotificationsManagerProtocol {
    private enum Constants {
        static let key = "jrns.notifications.is.enabled"
    }
    
    func hasUserEnabledNotificationsAtIOSLevel(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            case .denied:
                completion(false)
            default:
                completion(false)
            }
        }
    }

    func hasUserEnabledNotifications(completion: @escaping (Bool) -> Void) {
        hasUserEnabledNotificationsAtIOSLevel()  { result in
            guard result else {
                completion(false)
                return
            }
            completion(UserDefaults.standard.bool(forKey: Constants.key))
        }
    }

    func toggleNotifications(isOn: Bool, completion: @escaping (Bool) -> Void) {
        guard isOn else {
            UserDefaults.standard.set(false, forKey: Constants.key)
            completion(false)
            return
        }
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                UserDefaults.standard.set(true, forKey: Constants.key)
                completion(true)
            case .denied:
                UserDefaults.standard.set(false, forKey: Constants.key)
                completion(false)
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { granted, error in
                    if let error {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                    guard granted else {
                        UserDefaults.standard.set(false, forKey: Constants.key)
                        completion(false)
                        return
                    }
                    UserDefaults.standard.set(true, forKey: Constants.key)
                    completion(true)
                })
            default:
                UserDefaults.standard.set(true, forKey: Constants.key)
                completion(true)
            }
        }
//        guard isOn else {
//            UserDefaults.standard.set(false, forKey: Constants.key)
//            return false
//        }
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            if settings.authorizationStatus != .authorized {
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { _, error in
//                    if error != nil {
//                        print("=== Error occured")
//                    }
//                })
//            }
//        }
//        UserDefaults.standard.set(true, forKey: Constants.key)
//        return true
    }
}
