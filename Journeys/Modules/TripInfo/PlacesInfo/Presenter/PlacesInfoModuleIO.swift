//
//  PlacesIngoModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

// MARK: - PlacesIngo ModuleInput

protocol PlacesInfoModuleInput: AnyObject {
}

// MARK: - PlacesIngo ModuleOutput

protocol PlacesInfoModuleOutput: AnyObject {
    func placesModuleWantsToClose()
}
