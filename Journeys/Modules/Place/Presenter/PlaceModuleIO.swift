//
//  PlaceModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

// MARK: - Place ModuleInput

protocol PlaceModuleInput: AnyObject {
}

// MARK: - Place ModuleOutput

protocol PlaceModuleOutput: AnyObject {
    func placeModuleWantsToClose()
}
