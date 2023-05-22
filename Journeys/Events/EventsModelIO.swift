//
//  EventsModelIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 09.04.2023.
//

import Foundation

// MARK: - Place ModuleInput

protocol EventsModelInput: AnyObject {
    func loadPlacemarks(completion: @escaping (Result<[Address], Error>) -> Void)
}

// MARK: - Place ModuleOutput

protocol EventsModelOutput: AnyObject {
}

