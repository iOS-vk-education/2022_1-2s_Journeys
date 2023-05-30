//
//  RouteModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation
import UIKit

// MARK: - RouteModel

final class RouteModel {
    weak var output: RouteModelOutput!
    private let FBService: FirebaseServiceProtocol
    private var helper: StoreNewTrip?
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.FBService = firebaseService
    }
}

extension RouteModel: RouteModelInput {
    func storeRouteData(route: Route, tripImage: UIImage, tripId: String) {
        FBService.storeImage(image: tripImage, imageType: .trip) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output.didRecieveError(error: .saveDataError)
            case .success(let url):
                strongSelf.didStoreImageData(url: url, route: route)
            }
        }
    }
    
    func didStoreImageData(url: String, route: Route) {
        let newRoute = Route(id: route.id,
                             imageURLString: url,
                             departureLocation: route.departureLocation,
                             places: route.places)
        FBService.storeRouteData(route: newRoute) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output.didRecieveError(error: .saveDataError)
            case .success(let route):
                strongSelf.output.didSaveRouteData(route: route)
            }
        }
    }
    
    func storeNewTrip(route: Route, tripImage: UIImage) {
        helper = StoreNewTrip(route: route,
                              tripImage: tripImage,
                              firebaseService: FBService,
                              output: self)
        helper?.start()
    }
    
    func saveNotifications(for route: Route, completion: @escaping (Route) -> Void) {
        var newRoute: Route = route
        let notificationCenterQueue = DispatchQueue.global()
        let notificationCenterDispatchGroup = DispatchGroup()
        for (index, place) in newRoute.places.enumerated() {
            // Schedule the request with the system.
            if let notification = place.notification {
                
                notificationCenterDispatchGroup.enter()
                notificationCenterQueue.async(group: notificationCenterDispatchGroup, flags: .barrier) { [weak self] in
                    self?.storeNotification(notification) { notification in
                        if let notification {
                            newRoute.places[index].notification = notification
                        }
                        notificationCenterDispatchGroup.leave()
                    }
                }
            }
        }
        notificationCenterDispatchGroup.notify(queue: notificationCenterQueue) {
            completion(newRoute)
        }
    }
    
    private func storeNotification(_ notification: PlaceNotification, completion: @escaping (PlaceNotification?) -> Void) {
        var newNotification = notification
        
        let uuidString =  UUID().uuidString
        newNotification.id = uuidString
        
        let content = UNMutableNotificationContent()
        content.title = newNotification.contentTitle
        content.body = newNotification.contentBody
        content.userInfo = ["tripId": notification.tripId ?? ""]
        content.badge = 1
        
        // Create the trigger as a repeating event.
        let seconds = newNotification.date.timeIntervalSince1970 - Date().timeIntervalSince1970
        guard seconds > 0 else {
            completion(nil)
            return
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content,
                                            trigger: trigger)
        
        NotificationsManager.shared.notificationCenter.add(request) { (error) in
            if error == nil {
                completion(newNotification)
                return
            }
            completion(nil)
        }
    }
    
    func deleteOutDatedNotifications(oldNotifications: [PlaceNotification], newNotifications: [PlaceNotification]) {
        var notificationsIds: [String] = []
        for newNotification in newNotifications {
            let sameNotifications: [PlaceNotification] = oldNotifications.filter {
                $0.id == newNotification.id && $0 != newNotification
            }
            if !sameNotifications.isEmpty {
                notificationsIds.append(contentsOf: sameNotifications.compactMap {$0.id})
            }
        }
        if !notificationsIds.isEmpty {
            NotificationsManager.shared.deleteNotifications(with: notificationsIds)
        }
    }
    
    func deleteNotification(_ notification: PlaceNotification) {
        guard let notificationId = notification.id else { return }
        NotificationsManager.shared.deleteNotifications(with: [notificationId])
    }
}

extension RouteModel: StoreNewTripOutput {
    func saveFinished(trip: Trip, route: Route) {
        output.didSaveData(trip: trip, route: route)
    }
    
    func saveError() {
        output.didRecieveError(error: .saveDataError)
    }
}

