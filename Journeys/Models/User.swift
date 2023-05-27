//
//  UserModel.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation
import FirebaseAuth

struct User {
    var id: String?
    var email: String?
    var name: String?
    var lastName: String?
    
    internal init(id: String? = nil, email: String? = nil, name: String? = nil, lastName: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.lastName = lastName
    }
    
    init?(from auth: AuthDataResult) {
        guard let email =  auth.user.email else { return nil }
        self.email = email
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard let email = dictionary[CodingKeys.email.rawValue] as? String?,
              let name = dictionary[CodingKeys.name.rawValue] as? String?,
              let lastName = dictionary[CodingKeys.lastName.rawValue] as? String? else {
            return nil
        }
        self.email = email
        self.name = name
        self.lastName = lastName
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.email.rawValue] = email
        dictionary[CodingKeys.name.rawValue] = name
        dictionary[CodingKeys.lastName.rawValue] = lastName
        return dictionary
    }
    
    func fullName() -> String? {
        if let name {
            if let lastName {
                return name + " " + lastName
            }
            return name
        }
        return nil
    }
    
    enum CodingKeys: String {
        case id
        case email
        case name
        case lastName = "last_name"
    }
}
