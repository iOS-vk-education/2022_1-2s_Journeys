//
//  AccountInfoModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//


// MARK: - AccountInfoModel
final class AccountInfoModel {
    private let firebaseService: FirebaseServiceProtocol
    weak var output: AccountInfoModelOutput?
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
    
    private func deleteAccountRelatedInfo(completion: @escaping (Error?) -> Void) {
        firebaseService.deleteAccountRelatedData(completion: completion)
    }
}

extension AccountInfoModel: AccountInfoModelInput {
    func getUserData() {
        firebaseService.obtainCurrentUserData { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output?.didRecieveError(error: error)
            case .success(let user):
                self?.output?.didObtainUserData(data: user)
            }
            
        }
    }
    
    func signOut() {
        firebaseService.signOut { [weak self] error in
            guard let self else { return }
            if let error {
                self.output?.didRecieveError(error: error)
                return
            }
        }
    }
    
    func saveEmail(email: String, newEmail: String, password: String, completion: (() -> Void)?) {
        firebaseService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output?.didRecieveError(error: error)
            case .success:
                self.firebaseService.updateUserEmail(email: newEmail, password: password) { error in
                    if let error {
                        self.output?.didRecieveError(error: error)
                        return
                    }
                    completion?()
                    self.output?.didStoreData(.email(self.firebaseService.currentUserEmail()))
                }
            }
        }
    }
    
    func savePassword(email: String, password: String, newPassword: String) {
        firebaseService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output?.didRecieveError(error: error)
            case .success:
                self.firebaseService.updateUserPassword(email: email,
                                                        password: password,
                                                        newPassword: newPassword) { error in
                    if let error {
                        self.output?.didRecieveError(error: error)
                        return
                    }
                    self.output?.didStoreData(.password)
                }
            }
        }
    }
    
    func saveUserData(_ data: User) {
        firebaseService.storeUserData(data) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output?.didRecieveError(error: error)
            case .success(let user):
                self?.output?.didStoreData(.personalInfo(user))
            }
        }
    }
    
    func deleteUser(with password: String) {
        deleteUserData { [weak self] error in
            if let error {
                self?.output?.didRecieveError(error: error)
                return
            }
            self?.deleteAccount(with: password) { [weak self] error in
                if let error {
                    self?.output?.didRecieveError(error: error)
                    return
                }
                self?.output?.deleteSuccesfull()
            }
        }
    }
    
    private func deleteUserData(completion: @escaping (Error?) -> Void) {
        firebaseService.deleteCurrentUserData(completion: completion)
    }
    
    private func deleteAccount(with password: String, completion: @escaping (Error?) -> Void) {
        firebaseService.deleteAccount(with: password, completion: completion)
    }
}

