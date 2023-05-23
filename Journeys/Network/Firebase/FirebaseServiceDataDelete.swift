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
    func deleteTripImage(for imageURLString: String, completion: @escaping (Error?) -> Void)
    func deleteAccountRelatedData(completion: @escaping (Error?) -> Void)
    func deleteTrips(uid: String, completion: @escaping (Error?) -> Void)
    func deleteRouteData(routeId: String, completion: @escaping (Error?) -> Void)
    func deleteUserData(uid: String)
    
    func deleteBaggage(baggageId: String)
    func deleteStuffData(_ stuffId: String, baggageId: String, completion: @escaping (Error?) -> Void)
    func deleteUserCertainStuff(_ stuffId: String, completion: @escaping (Error?) -> Void)
    func deleteStuffList(_ stuffListId: String, completion: @escaping (Error?) -> Void)
}

extension FirebaseService: FirebaseServiceDeleteProtocol {
    // MARK: Delete data
    func deleteAccountRelatedData(completion: @escaping (Error?) -> Void) {
        // TODO: implement data deletion
    }
    
    func deleteTrips(uid: String, completion: @escaping (Error?) -> Void) {
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
            completion(Errors.deleteDataError)
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
    
    func deleteUserCertainStuff(_ stuffId: String, completion: @escaping (Error?) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            completion(Errors.deleteDataError)
            return
        }
        firebaseManager.firestore.collection("stuff").document(userId)
            .collection("user_stuff").document(stuffId).delete(completion: completion)
    }
    
    func deleteStuffList(_ stuffListId: String, completion: @escaping (Error?) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            completion(Errors.deleteDataError)
            return
        }
        firebaseManager.firestore.collection("stuff_lists").document(userId)
            .collection("user_stuff_lists").document(stuffListId).delete(completion: completion)
    }
    
    func deleteCurrentUserData(completion: @escaping (Error?) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            completion(Errors.deleteDataError)
            return
        }
        
        firebaseManager.firestore.collection("users").document(userId).delete(completion: completion)
    }
}
    
