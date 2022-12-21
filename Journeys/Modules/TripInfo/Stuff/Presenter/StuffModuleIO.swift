//
//  StuffModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

// MARK: - Stuff ModuleInput

protocol StuffModuleInput: AnyObject {
}

// MARK: - Stuff ModuleOutput

protocol StuffModuleOutput: AnyObject {
    func stuffModuleWantsToClose()
}
