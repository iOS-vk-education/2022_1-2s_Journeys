//
//  UserModel.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation
import FirebaseAuth

struct User {
    var email: String
    
    init(email: String) {
        self.email = email
    }
    
    init?(from auth: AuthDataResult) {
        guard let email =  auth.user.email else { return nil }
        self.email = email
    }
    
    init?(from dictionary: [String: Any]) {
        guard let email = dictionary[CodingKeys.email.rawValue] as? String else {
            return nil
        }
        self.email = email
    }
    
    enum CodingKeys: String {
        case email
    }
}
