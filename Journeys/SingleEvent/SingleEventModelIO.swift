//
//  SingleEventModelIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 16.05.2023.
//

import Foundation
import UIKit

// MARK: - Place ModuleInput

protocol SingleEventModelInput: AnyObject {
    func loadEvent(eventId: String)
    func setLike(eventId: String)
    func removeLike(eventId: String)
    func checkLike(completion: @escaping (Result<[FavoritesEvent], Error>) -> Void)
}

// MARK: - Place ModuleOutput

protocol SingleEventModelOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didRecieveData(event: Event)
    func didReciveImage(image: UIImage)
    func didResiveLikeTrue()
}
