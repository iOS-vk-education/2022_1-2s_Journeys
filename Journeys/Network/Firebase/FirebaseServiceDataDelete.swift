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
}

extension FirebaseService: FirebaseServiceDeleteProtocol {
    // MARK: Delete data
    
    func deleteTripData(_ trip: Trip, completion: @escaping (Error?) -> Void) {
        guard let userId = FBManager.auth.currentUser?.uid else {
//            assertionFailure("Login first")
            return
        }
        guard let id = trip.id else { return }
        FBManager.firestore.collection("trips").document(userId)
            .collection("user_trips").document(id).delete { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }
    
    func deleteStuffData(_ stuffId: String, baggageId: String, completion: @escaping (Error?) -> Void) {
        FBManager.firestore.collection("baggage").document(baggageId)
            .collection("baggage_stuff").document(stuffId).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
    
