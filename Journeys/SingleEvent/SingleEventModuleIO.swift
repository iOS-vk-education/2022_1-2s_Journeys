//
//  SingleEventModuleIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 16.05.2023.
//

import Foundation

protocol SingleEventModuleInput: AnyObject {
}

// MARK: - Events ModuleOutput

protocol SingleEventModuleOutput: AnyObject {
    func wantsToOpenLink(link: URL)
}
