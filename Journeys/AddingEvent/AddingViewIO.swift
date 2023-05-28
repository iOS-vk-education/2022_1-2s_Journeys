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
    
}

// MARK: - Events ViewOutput
protocol AddingViewOutput: AnyObject {
    func imageFromView(image: UIImage?)
    func saveData(post: Event)
    func backToSuggestionVC()
    func displayAddress() -> String?
}
