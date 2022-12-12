//
//  NewRouteCreatingModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation

protocol NewRouteCreatingModelInput: AnyObject {
    func loadRoute(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void)
//    func loadLocation(with identifier: String, completion: @escaping (Result<Location, Error>) -> Void)
}
