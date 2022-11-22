//
//  AddNewLocationModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

// MARK: - AddNewLocation ModuleInput

protocol AddNewLocationModuleInput: AnyObject {
}

// MARK: - AddNewLocation ModuleOutput

protocol AddNewLocationModuleOutput: AnyObject {
    func addNewLoctionModuleWantsToClose()
}
