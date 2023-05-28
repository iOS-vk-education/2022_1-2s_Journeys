//
//  AccountModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

// MARK: - AccountModel

final class AccountModel {
    private let firebaseService: FirebaseServiceProtocol
    weak var output: AccountModelOutput?
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
}

extension AccountModel: AccountModelInput {
    func getUserData() {
        firebaseService.obtainCurrentUserData { [weak self] result in
            switch result {
            case .failure:
                self?.output?.didRecieveError(error: .obtainDataError)
            case .success(let user):
                self?.output?.didObtainUserData(data: user)
            }
        }
    }
}
