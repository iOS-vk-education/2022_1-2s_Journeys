//
//  AccountModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//


// MARK: - AccountModel

final class AccountModel {
    private let firebaseService: FirebaseServiceProtocol
    weak var output: AccountModelOutput!
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
}

extension AccountModel: AccountModelInput {
    
    func getUserData() -> User? {
        firebaseService.obtainUserData()
    }
    
    func signOut() {
        firebaseService.signOut { [weak self] error in
            guard let self else { return }
            if let error {
                self.output.didRecieveError(error: error)
                return
            }
        }
    }
    func saveEmail(email: String, password: String) {
        firebaseService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output.didRecieveError(error: error)
            case .success:
                self.firebaseService.updateUserEmail(email: email, password: password) { error in
                    if let error {
                        self.output.didRecieveError(error: error)
                        return
                    }
                    self.output.saveSuccesfull()
                }
            }
        }
    }
    
    func saveNewPassword(email: String, password: String, newPassword: String) {
        firebaseService.updateUserPassword(email: email, password: password, newPassword: password) { [weak self] error in
            if let error {
                self?.output.didRecieveError(error: error)
                return
            }
            self?.output.saveSuccesfull()
        }
    }
    
    func saveEmail(email: String, newEmail: String, password: String) {
        firebaseService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output.didRecieveError(error: error)
            case .success:
                self.firebaseService.updateUserEmail(email: newEmail, password: password) { error in
                    if let error {
                        self.output.didRecieveError(error: error)
                        return
                    }
                    self.output.saveSuccesfull()
                }
            }
        }
    }
    
    func savePassword(email: String, password: String, newPassword: String) {
        firebaseService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output.didRecieveError(error: error)
            case .success:
                self.firebaseService.updateUserPassword(email: email,
                                                        password: password,
                                                        newPassword: newPassword) { error in
                    if let error {
                        self.output.didRecieveError(error: error)
                        return
                    }
                    self.output.saveSuccesfull()
                }
            }
        }
    }
    
    func saveEmailAndPassword(email: String, newEmail: String, password: String, newPassword: String) {
        firebaseService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output.didRecieveError(error: error)
            case .success:
                self.firebaseService.updateUserEmail(email: newEmail, password: password) { error in
                    if let error {
                        self.output.didRecieveError(error: error)
                        return
                    }
                    self.firebaseService.updateUserPassword(email: newEmail,
                                                            password: password,
                                                            newPassword: newPassword) { error in
                        if let error {
                            self.output.didRecieveError(error: error)
                            return
                        }
                        self.output.saveSuccesfull()
                    }
                }
            }
        }
    }
    
}
