//
//  AddingModelIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 10.04.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol AddingModelInput: AnyObject {
    func storeAddingData(event: Event, eventImage: UIImage, coordinatesId: String)
    func createStory(coordinates: Adress, event: Event, eventImage: UIImage)
}

protocol AddingModelOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didSaveAddingData(event: Event)
    func didStoreImageData(url: String, event: Event, coordinatesId: String)
    func didSaveData(address: Adress, event: Event)
}
