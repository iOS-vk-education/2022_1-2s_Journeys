//
//  PlaceModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

// MARK: - PlaceModel

final class PlaceModel {
    weak var output: PlaceModelOutput!
    private let FBService: FirebaseServiceProtocol
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.FBService = firebaseService
    }
}

extension PlaceModel: PlaceModelInput {
}
