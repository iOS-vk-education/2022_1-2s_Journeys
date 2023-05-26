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
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.FBService = firebaseService
    }
}

extension RouteModel: RouteModelInput {
    func storeRouteData(route: Route, tripImage: UIImage, tripId: String) {
        FBService.storeTripImage(image: tripImage) { [weak self] result in
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
        let helper = StoreNewTrip(route: route,
                                  tripImage: tripImage,
                                  firebaseService: FBService,
                                  output: self)
        helper.start()
    }
    
    func saveNotifications(for route: Route, completion: @escaping (Route) -> Void) {
        var newRoute: Route = route
        for (index, place) in newRoute.places.enumerated() {
            // Schedule the request with the system.
            let notificationCenterQueue = DispatchQueue.global()
            let notificationCenterDispatchGroup = DispatchGroup()
            
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
            
            notificationCenterDispatchGroup.notify(queue: notificationCenterQueue) {
                completion(newRoute)
            }
        }
    }
    
    private func storeNotification(_ notification: PlaceNotification, completion: @escaping (PlaceNotification?) -> Void) {
        var newNotification = notification
        
        let uuidString =  UUID().uuidString
        newNotification.id = uuidString
        
        let content = UNMutableNotificationContent()
        content.title = newNotification.contentTitle
        content.body = newNotification.contentBody
        content.badge = 1
        
        // Configure the recurring date.
        var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: newNotification.date)
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content,
                                            trigger: trigger)
        
        NotificationsManager.shared.sheduleNewNotification(request) { (error) in
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

