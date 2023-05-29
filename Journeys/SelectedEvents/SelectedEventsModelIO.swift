//
//  SelectedEventsModelIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation
import UIKit

// MARK: - Events ViewInput
protocol SelectedEventsModelInput: AnyObject {
    func loadEvents(completion: @escaping (Result<[Event], Error>) -> Void)
    func loadImage(photoURL: String)
    func deleteEvent(eventId: String)
    func deleteLike(eventId: String)
    func setLike(eventId: String)
    func checkLike(completion: @escaping (Result<[FavoritesEvent], Error>) -> Void)
    func loadLikedEvents(identifiers: [String], events: [Event], completion: @escaping (Result<[Event], Error>) -> Void)
}

// MARK: - Events ViewOutput
protocol SelectedEventsModelOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didReciveImage(image: UIImage)
    func didDeleteEvent()
    func didRemoveLike()
}
