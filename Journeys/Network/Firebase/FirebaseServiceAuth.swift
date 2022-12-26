//
//  FirebaseServiceAuth.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol FirebaseServiceAuthProtocol {
    func createUser(email: String,
                    password: String,
                    completion: @escaping (Result<User, Error>) -> Void)
    func login(email: String,
               password: String,
               completion: @escaping (Result<User, Error>) -> Void)
    func signOut(completion: @escaping (Error?) -> Void)
    func updateUserEmail(email: String,
                         password: String,
                         completion: @escaping (Error?) -> Void)
    func updateUserPassword(email: String,
                            password: String,
                            newPassword: String,
                            completion: @escaping (Error?) -> Void)
    func obtainUserData() -> User?
}

extension FirebaseService: FirebaseServiceAuthProtocol {
    
    func createUser(email: String,
                    password: String,
                    completion: @escaping (Result<User, Error>) -> Void) {
        FBManager.auth.createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(.failure(error))
            }
            guard let result else {
                completion(.failure(FBError.authError))
                return
            }
            guard let user = User(from: result) else {
                completion(.failure(FBError.authError))
                return
            }
            completion(.success(user))
        }
    }
    
    func login(email: String,
               password: String,
               completion: @escaping (Result<User, Error>) -> Void) {
        FBManager.auth.signIn(withEmail: email, password: password) { result, error in
            if let error {
                completion(.failure(error))
            }
            guard let result else {
                completion(.failure(FBError.authError))
                return
            }
            guard let user = User(from: result) else {
                completion(.failure(FBError.authError))
                return
            }
            completion(.success(user))
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try FBManager.auth.signOut()
            completion(nil)
        } catch {
            completion(FBError.signOutError)
        }
    }
    
    func obtainUserData() -> User? {
        let user = FBManager.auth.currentUser
        if let user = user,
           let email = user.email {
            return User(email: email)
        }
        return nil
    }
    
    // MARK: Store data
    
    func updateUserEmail(email: String, password: String, completion: @escaping (Error?) -> Void) {
//        login(email: email, password: password) { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .failure(let error):
//                completion(error)
//            case .success(let user):
//                self.FBManager.auth.currentUser?.updateEmail(to: email) { error in
//                    if let error {
//                        completion(error)
//                        return
//                    }
//                    completion(nil)
//                }
//            }
//        }
        FBManager.auth.currentUser?.updateEmail(to: email) { error in
            if let error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func updateUserPassword(email: String,
                            password: String,
                            newPassword: String,
                            completion: @escaping (Error?) -> Void) {
        login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let user):
                self.FBManager.auth.currentUser?.updateEmail(to: email) { error in
                    if let error {
                        completion(error)
                        return
                    }
                    self.FBManager.auth.currentUser?.updatePassword(to: newPassword) { error in
                        if let error {
                            completion(error)
                            return
                        }
                        completion(nil)
                    }
                }
            }
        }
    }
    
}
