//
//  EventsModuleIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 09.04.2023.
//

// MARK: - Events ModuleInput

protocol EventsModuleInput: AnyObject {
}

// MARK: - Events ModuleOutput

protocol EventsModuleOutput: AnyObject {
    func wantsToOpenAddEventVC()
    func wantsToOpenSingleEventVC(id: String)
    func closeOpenSingleEventVCIfExists()
}

