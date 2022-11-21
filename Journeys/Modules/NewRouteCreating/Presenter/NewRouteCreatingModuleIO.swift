//
//  NewRouteCreatingModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

// MARK: - NewRouteCreating ModuleInput

protocol NewRouteCreatingModuleInput: AnyObject {
}

// MARK: - NewRouteCreating ModuleOutput

protocol NewRouteCreatingModuleOutput: AnyObject {
    func newRouteCreationModuleWantsToClose()
}
