//
//  AddingModuleIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 25.04.2023.
//
protocol AddingModuleInput: AnyObject {
}

// MARK: - Events ModuleOutput

protocol AddingModuleOutput: AnyObject {
    func wantsToOpenEventsVC()
    func backToSuggestionVC()
    func closeOpenSingleEventVCIfExists()
}
