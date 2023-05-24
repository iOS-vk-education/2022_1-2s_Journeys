//
//  StuffListsModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

// MARK: - StuffListsModel

final class StuffListsModel {
    weak var output: StuffListsModelOutput?
    private let firebaseService: FirebaseServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
}

extension StuffListsModel: StuffListsModelInput {
    func obtainStuffLists() {
        firebaseService.obtainStuffLists { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output?.didReceiveError(error)
            case .success(let stuffLists):
                self?.output?.didReceiveStuffLists(stuffLists)
            }
        }
    }
}
