//
//  AppRateManager.swift
//  Journeys
//
//  Created by Сергей Адольевич on 09.03.2023.
//

import Foundation
import StoreKit

// MARK: - AppRateManagerProtocol

protocol AppRateManagerProtocol {
    func explicitlyRateApplication()
    func rateApplicationIfAppropriate()
}

// MARK: - AppRateManager

final class AppRateManager: AppRateManagerProtocol {
    // MARK: Private data structures

    private enum Constants {
        static let lastRateDate = "jrns.last.rate.date"
        static let appRateCooldownInDays = 21
    }

    func explicitlyRateApplication() {
        guard let scene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first(where: { $0 is UIWindowScene }) as? UIWindowScene
        else {
            return
        }
        SKStoreReviewController.requestReview(in: scene)
        UserDefaults.standard.setValue(Date().timeIntervalSince1970, forKey: Constants.lastRateDate)
    }

    func rateApplicationIfAppropriate() {
        guard let lastDate = UserDefaults.standard.value(forKey: Constants.lastRateDate) as? TimeInterval else {
            explicitlyRateApplication()
            return
        }
        let lastRateDate = Date(timeIntervalSince1970: lastDate)
        var dayToAdd = DateComponents()
        dayToAdd.day = 1
        if let nextPossibleRateDate = Calendar.current.date(byAdding: dayToAdd, to: lastRateDate),
           Date() > nextPossibleRateDate {
            explicitlyRateApplication()
        }
    }
}
