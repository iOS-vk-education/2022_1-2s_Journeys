//
//  FirebaseService.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol FirebaseServiceDeleteProtocol {
    func deleteTripData(_ trip: Trip, completion: @escaping (Error?) -> Void)
    func deleteStuffData(_ stuffId: String, baggageId: String, completion: @escaping (Error?) -> Void)
    func deleteTripImage(for imageURLString: String, completion: @escaping (Error?) -> Void)
    func deleteAccountRelatedData(completion: @escaping (Error?) -> Void)
    func deleteTrips(uid: String, completion: @escaping (Error?) -> Void)
    func deleteRouteData(routeId: String, completion: @escaping (Error?) -> Void)
    func deleteBaggage(baggageId: String)
    func deleteUserData(uid: String)
}

extension FirebaseService: FirebaseServiceDeleteProtocol {
    // MARK: Delete data
    func deleteAccountRelatedData(completion: @escaping (Error?) -> Void) {
        // TODO: implement data deletion
    }
    
    func deleteTrips(uid: String, completion: @escaping (Error?) -> Void) {
        obtainTrips { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let trips):
                for trip in trips {
                    self.deleteRouteData(routeId: trip.routeId) { error in
                        completion(error)
                    }
                    self.deleteBaggage(baggageId: trip.baggageId)
                }
                self.deleteUserData(uid: uid)
            }
        }
        // TODO: implement trips data deletion
    }
    
    func deleteRouteData(routeId: String, completion: @escaping (Error?) -> Void) {
        // TODO: implement data deletion
    }
        
    func deleteBaggage(baggageId: String) {
        // TODO: implement data deletion
    }
    
    func deleteUserData(uid: String) {
        // TODO: implement data deletion
    }
    
    func deleteTripData(_ trip: Trip, completion: @escaping (Error?) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        guard let id = trip.id else { return }
        firebaseManager.firestore.collection("trips").document(userId)
            .collection("user_trips").document(id).delete(completion: completion)
    }
    
    func deleteTripImage(for imageURLString: String, completion: @escaping (Error?) -> Void) {
        firebaseManager.storage.reference(forURL: imageURLString).delete(completion: completion)
    }
    
    func deleteStuffData(_ stuffId: String, baggageId: String, completion: @escaping (Error?) -> Void) {
        firebaseManager.firestore.collection("baggage").document(baggageId)
            .collection("baggage_stuff").document(stuffId).delete (completion: completion)
    }
}
    
