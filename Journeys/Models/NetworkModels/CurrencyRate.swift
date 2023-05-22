//
//  CurrencyRate.swift
//  Journeys
//
//  Created by Сергей Адольевич on 13.04.2023.
//

import Foundation

struct CurrencyRate: Decodable {
    let newAmount: Float
    let newCurrency: String
    let oldCurrency: String
    let oldAmount: Float
    
    enum CodingKeys: String, CodingKey {
        case newAmount = "new_amount"
        case newCurrency = "new_currency"
        case oldCurrency = "old_currency"
        case oldAmount = "old_amount"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        newAmount = try values.decode(Float.self, forKey: .newAmount)
        newCurrency = try values.decode(String.self, forKey: .newCurrency)
        oldCurrency = try values.decode(String.self, forKey: .oldCurrency)
        oldAmount = try values.decode(Float.self, forKey: .oldAmount)
    }
}
