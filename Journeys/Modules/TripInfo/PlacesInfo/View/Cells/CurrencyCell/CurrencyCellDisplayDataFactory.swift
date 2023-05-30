//
//  CurrencyCellDisplayDataFactory.swift
//  Journeys
//
//  Created by Сергей Адольевич on 03.05.2023.
//

import Foundation

protocol CurrencyCellDisplayDataFactoryProtocol: AnyObject {
    func displayData(locationsWithCurrencyRate: LocationsWithCurrencyRate) -> CurrencyCell.DisplayData
}

final class CurrencyCellDisplayDataFactory: CurrencyCellDisplayDataFactoryProtocol {
    func displayData(locationsWithCurrencyRate: LocationsWithCurrencyRate) -> CurrencyCell.DisplayData {
        let title = locationsWithCurrencyRate.locations
            .compactMap({ $0.city }).joined(separator: ", ")
        return CurrencyCell.DisplayData(title: title,
                                        currentCurrencyAmount: String(locationsWithCurrencyRate.currencyRate.oldAmount)
            .replacingOccurrences(of: ".", with: ","),
                                        localCurrencyAmount: String(locationsWithCurrencyRate.currencyRate.newAmount)
            .replacingOccurrences(of: ".", with: ","),
                                        currentCurrencyName: locationsWithCurrencyRate.currencyRate.oldCurrency,
                                        localCurrencyName: locationsWithCurrencyRate.currencyRate.newCurrency)
    }
}
