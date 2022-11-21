//
//  Place.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

struct Place {
    var country: String
    var town: String
    var arrive: Date?
    var depart: Date?
    var weather: [Weather]
}
