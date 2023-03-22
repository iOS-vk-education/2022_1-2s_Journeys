//
//  AuthModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

// MARK: - AuthModel

final class AuthModel {
    private let firebaseService: FirebaseServiceProtocol
    weak var output: AuthModelOutput!
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
}

extension AuthModel: AuthModelInput {
    func createAccount(email: String, password: String) {
        firebaseService.createUser(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output.didRecieveError(error: error)
            case .success:
                self.output.authSuccesfull()
            }
        }
    }
    
    func login(email: String, password: String) {
        firebaseService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                self.output.didRecieveError(error: error)
            case .success:
                self.output.authSuccesfull()
            }
        }
    }
    
    func resetPassword(for email: String) {
        firebaseService.resetPassword(for: email) { [weak self] error in
            guard let error else {
                self?.output.resetSuccesfull(for: email)
                return
            }
            self?.output.didRecieveError(error: error)
        }
    }
}
