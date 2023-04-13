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

enum AuthErrors: Error {
    case accountTroubles
}

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
    func resetPassword(for email: String, completion: @escaping (Error?) -> Void)
    func deleteAccount(with password: String, completion: @escaping (Error?) -> Void)
    func obtainUserData() -> User?
}

extension FirebaseService: FirebaseServiceAuthProtocol {
    
    func createUser(email: String,
                    password: String,
                    completion: @escaping (Result<User, Error>) -> Void) {
        firebaseManager.auth.createUser(withEmail: email, password: password) { result, error in
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
        firebaseManager.auth.signIn(withEmail: email, password: password) { result, error in
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
            try firebaseManager.auth.signOut()
            completion(nil)
        } catch {
            completion(FBError.signOutError)
        }
    }
    
    func obtainUserData() -> User? {
        let user = firebaseManager.auth.currentUser
        if let user = user,
           let email = user.email {
            return User(email: email)
        }
        return nil
    }
    
    // MARK: Store data
    
    func updateUserEmail(email: String, password: String, completion: @escaping (Error?) -> Void) {
        firebaseManager.auth.currentUser?.updateEmail(to: email) { error in
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
                self.firebaseManager.auth.currentUser?.updateEmail(to: email) { error in
                    if let error {
                        completion(error)
                        return
                    }
                    self.firebaseManager.auth.currentUser?.updatePassword(to: newPassword) { error in
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
    
    func resetPassword(for email: String, completion: @escaping (Error?) -> Void) {
        firebaseManager.auth.sendPasswordReset(withEmail: email, completion: completion)
    }
    
    func deleteAccount(with password: String, completion: @escaping (Error?) -> Void) {
        guard let email = firebaseManager.auth.currentUser?.email else {
            return
        }
        login(email: email,
              password: password) { [weak self] result in
            switch result {
            case .failure(let error): completion(error)
            case .success:
                self?.firebaseManager.auth.currentUser?.delete(completion: completion)
            }
        }
    }
    
    func checkPassword(password: String, completion: @escaping (Error?) -> Void) {
        guard let email = firebaseManager.auth.currentUser?.email else { return }
        firebaseManager.auth.signIn(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }
}
