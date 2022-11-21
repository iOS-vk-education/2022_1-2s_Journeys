//
//  Weather.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

enum WeatherFeature {
    case cloudy
    case sunny
    case rainy
    case stormy
}

struct Weather {
    var date: Date
    var temperature: Int
    var weatherFeature: WeatherFeature
}
