//
//  AuthModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

// MARK: - AuthModel

final class AuthModel {
    private let firebaseService: FirebaseServiceProtocol
    weak var output: AuthModelOutput?
    private let baseStuffListHelper: StoreBaseStuffList
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
        baseStuffListHelper = StoreBaseStuffList(firebaseService: firebaseService)
    }
}

extension AuthModel: AuthModelInput {
    func createAccount(email: String, password: String) {
        firebaseService.createUser(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output?.didRecieveError(error: error)
            case .success:
                self.output?.authSuccesfull()
                let user = User(email: email)
                self.saveUserData(user)
                self.createBaseStuffList()
            }
        }
    }
    
    func saveUserData(_ data: User) {
        firebaseService.storeUserData(data) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output?.didRecieveError(error: error)
            case .success:
                break
            }
        }
    }
    
    private func createBaseStuffList() {
        baseStuffListHelper.start()
    }
    
    func login(email: String, password: String) {
        firebaseService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output?.didRecieveError(error: error)
            case .success:
                self.output?.authSuccesfull()
            }
        }
    }
    
    func resetPassword(for email: String) {
        firebaseService.resetPassword(for: email) { [weak self] error in
            guard let error else {
                self?.output?.resetSuccesfull(for: email)
                return
            }
            self?.output?.didRecieveError(error: error)
        }
    }
}
