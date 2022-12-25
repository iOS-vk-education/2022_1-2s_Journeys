//
//  FirebaseStoreProtocol.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation

protocol FirebaseServiceProtocol: AnyObject,
                                  FirebaseServiceStoreProtocol,
                                  FirebaseServiceDeleteProtocol,
                                  FirebaseServiceAuthProtocol,
                                  FirebaseServiceObtainProtocol {
    
}

class FirebaseService: FirebaseServiceProtocol {
    let FBManager = FirebaseManager.shared
}
