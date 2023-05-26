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
    
    func deleteNotifications(with identifiers: [String])
    func sheduleNewNotification(_ notificationRequest: UNNotificationRequest,
                                completion: @escaping (Error?) -> Void)
}

// MARK: - NotificationsManager

final class NotificationsManager: NotificationsManagerProtocol {
    
    static let shared = NotificationsManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    private enum Constants {
        static let key = "jrns.notifications.is.enabled"
    }
    
    private init() {
    }
    
    private func askNotificationsPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { granted, error in
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
        notificationCenter.getNotificationSettings { settings in
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
        notificationCenter.getNotificationSettings { [weak self] settings in
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
    
    func deleteNotifications(with identifiers: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func sheduleNewNotification(_ notificationRequest: UNNotificationRequest,
                                completion: @escaping (Error?) -> Void) {
        notificationCenter.add(notificationRequest, withCompletionHandler: completion)
    }
}
