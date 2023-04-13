//
//  AccountInfoModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//


// MARK: - AccountInfoModel

enum UserData {
    case email
    case password
}

final class AccountInfoModel {
    private let firebaseService: FirebaseServiceProtocol
    weak var output: AccountInfoModelOutput!
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
    
    private func deleteAccountRelatedInfo(completion: @escaping (Error?) -> Void) {
        firebaseService.deleteAccountRelatedData(completion: completion)
    }
}

extension AccountInfoModel: AccountInfoModelInput {
    func userEmail() -> String? {
        firebaseService.obtainUserData()?.email
    }
    
    func getUserData() {
        guard let userData = firebaseService.obtainUserData() else { return }
        output.didObtainUserData(data: userData)
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
    
    func saveEmail(email: String, newEmail: String, password: String, completion: (() -> Void)?) {
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
                    self.output.saveSuccesfull(for: .email)
                    completion?()
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
                    self.output.saveSuccesfull(for: .password)
                }
            }
        }
    }
    
    func deleteAccount(with password: String) {
        firebaseService.deleteAccount(with: password) { [weak self] error in
            guard let error else {
                self?.output.deleteSuccesfull()
                return
            }
            self?.output.didRecieveError(error: error)
        }
    }
}

