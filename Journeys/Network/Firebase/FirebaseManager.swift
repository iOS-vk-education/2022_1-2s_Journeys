//
//  FirebaseManager.swift
//  Journeys
//
//  Created by Сергей Адольевич on 29.11.2022.
//

import Foundation
import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

final class FirebaseManager {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    private init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
}
