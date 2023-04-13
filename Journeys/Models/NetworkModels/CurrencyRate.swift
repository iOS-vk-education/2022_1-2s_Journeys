//
//  CurrencyRate.swift
//  Journeys
//
//  Created by Сергей Адольевич on 13.04.2023.
//

import Foundation

struct CurrencyRate: Decodable {
    let currentCurrency: String
    let newCurrency: String
    let course: Decimal
}
