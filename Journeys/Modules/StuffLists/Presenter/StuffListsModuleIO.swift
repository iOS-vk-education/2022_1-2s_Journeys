//
//  StuffListsModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

// MARK: - StuffLists ModuleInput

protocol StuffListsModuleInput: AnyObject {
}

// MARK: - StuffLists ModuleOutput

protocol StuffListsModuleOutput: AnyObject {
    func closeStuffListsModule()
    func openCertainStuffListModule(for stuffList: StuffList?)
}
