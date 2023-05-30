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
    func areNotificationsEnabledAtIOSLevel(completion: @escaping (Bool) -> Void)
}

// MARK: - NotificationsManager

final class NotificationsManager: NotificationsManagerProtocol {
    
    static let shared = NotificationsManager()
    
    private enum Constants {
        static let key = "jrns.notifications.is.enabled"
    }
    
    private func askNotificationsPermission(completion: @escaping (Bool) -> Void) {
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
    }
    
    func areNotificationsEnabledAtIOSLevel(completion: @escaping (Bool) -> Void) {
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
        areNotificationsEnabledAtIOSLevel()  { result in
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
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                UserDefaults.standard.set(true, forKey: Constants.key)
                completion(true)
            case .denied:
                UserDefaults.standard.set(false, forKey: Constants.key)
                completion(false)
            case .notDetermined:
                self?.askNotificationsPermission(completion: completion)
            default:
                UserDefaults.standard.set(true, forKey: Constants.key)
                completion(true)
            }
        }
    }
}
