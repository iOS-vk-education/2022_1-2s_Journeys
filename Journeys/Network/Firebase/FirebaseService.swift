//
//  FirebaseStoreProtocol.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation

enum FirebaseStoreageImageType {
    case trip
    case avatar
}


protocol FirebaseServiceProtocol: AnyObject,
                                  FirebaseServiceStoreProtocol,
                                  FirebaseServiceDeleteProtocol,
                                  FirebaseServiceAuthProtocol,
                                  FirebaseServiceObtainProtocol {
    
}

class FirebaseService: FirebaseServiceProtocol {
    let firebaseManager = FirebaseManager.shared
    
}
