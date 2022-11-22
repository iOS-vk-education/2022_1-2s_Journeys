//
//  Place.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

struct Location {
    var country: String
    var city: String
}

struct Place {
    var location: Location
    var arrive: Date?
    var depart: Date?
    var weather: [Weather]?
}
