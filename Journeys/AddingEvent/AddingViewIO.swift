//
//  AddingViewIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 25.04.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

// MARK: - Events ViewInput
protocol AddingViewInput: AnyObject {
    func showAlert1(title: String, message: String)
    
}

// MARK: - Events ViewOutput
protocol AddingViewOutput: AnyObject {
    func saveData(post: Event, coordinates: Adress, eventImage: UIImage)
    func openEventsVC()
    func backToSuggestionVC()
}
