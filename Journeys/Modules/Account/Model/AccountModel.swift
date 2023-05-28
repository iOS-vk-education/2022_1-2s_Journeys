//
//  AccountModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

import UIKit

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
            case .failure(let error):
                self?.output?.didRecieveError(error: error)
            case .success(let user):
                self?.output?.didObtainUserData(data: user)
            }
        }
    }
    
    func obtainAvatar(completion: @escaping (UIImage?) -> Void) {
        firebaseService.obtainImage(for: nil, imageType: .avatar) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(nil)
                return
            case .success(let image):
                completion(image)
            }
        }
    }
    
    func storeAvatar(_ avatar: UIImage, completion: @escaping (UIImage) -> Void) {
        firebaseService.storeImage(image: avatar, imageType: .avatar) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output?.didRecieveError(error: error)
            case .success(let avatarURL):
                completion(avatar)
            }
        }
    }
    
    func deleteAvatar() {
        firebaseService.deleteImage(url: nil, imageType: .avatar) { [weak self] error in
            if let error {
                self?.output?.didRecieveError(error: error)
                return
            } else {
                self?.output?.didDeleteImage()
            }
        }
    }
}
