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
    
    private func daysBetween(start: Date, end: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: start, to: end).day
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
            let content = UNMutableNotificationContent()
            content.title = "У вас запланирована поездка"
            content.body = "Завтра Вы отпрвляетесь в \(place.location.toString())"
            if let daysCount: Int = daysBetween(start: place.arrive, end: place.depart) {
                content.body.append(" на \(daysCount) дней")
            }
            
            // Configure the recurring date.
            if let date = Calendar.current.date(byAdding: .day, value: -1, to: place.arrive) {
                var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
                dateComponents.hour = 12
                // Create the trigger as a repeating event.
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                // Create the request
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString,
                                                    content: content,
                                                    trigger: trigger)
                
                newRoute.places[index].notificationId = uuidString
                
                // Schedule the request with the system.
                let notificationCenterQueue = DispatchQueue.global()
                let notificationCenterDispatchGroup = DispatchGroup()
                
                notificationCenterDispatchGroup.enter()
                notificationCenterQueue.async(group: notificationCenterDispatchGroup) {
                    NotificationsManager.shared.sheduleNewNotification(request) { (error) in
                        if error == nil,
                           let indexToCorrect = newRoute.places.firstIndex(where: { $0.notificationId == uuidString} ) {
                            newRoute.places[indexToCorrect].notificationId = nil
                        }
                        notificationCenterDispatchGroup.leave()
                    }
                }
                
                notificationCenterDispatchGroup.notify(queue: notificationCenterQueue) {
                    completion(newRoute)
                }
            }
        }
    }
    
    func deleteNotifications(for route: Route) {
        var notificationsIds: [String] = []
        for place in route.places {
            if let placeNotificationId = place.notificationId {
                notificationsIds.append(placeNotificationId)
            }
        }
        if !notificationsIds.isEmpty {
            NotificationsManager.shared.deleteNotifications(with: notificationsIds)
        }
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

