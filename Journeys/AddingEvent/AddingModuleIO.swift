//
//  AddingModuleIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 25.04.2023.
//
import FirebaseFirestore
protocol AddingModuleInput: AnyObject {
}

// MARK: - Events ModuleOutput

protocol AddingModuleOutput: AnyObject {
    func wantsToOpenEventsVC(coordinates: GeoPoint?)
    func backToSuggestionVC()
}
