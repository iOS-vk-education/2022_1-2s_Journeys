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
}

// MARK: - Events ViewOutput
protocol SelectedEventsModelOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didReciveImage(image: UIImage)
}
