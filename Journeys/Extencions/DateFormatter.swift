//
//  DateFormatter.swift
//  Journeys
//
//  Created by Сергей Адольевич on 22.11.2022.
//

import Foundation

extension DateFormatter {
    static var timeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
//
//    static var dayAndMonts: DateFormatter {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ru_RU")
//        dateFormatter.dateFormat = "dd MM"
//        return dateFormatter
//    }

    static var dayAndMonth: DateFormatter {
        let langCode: String = Locale.current.languageCode ?? ""
        let regCode: String = Locale.current.regionCode ?? ""
        let localCode: String = langCode + "_" + regCode
        let locale = Locale(identifier: localCode)

        var dateLocaleFormatter = DateFormatter.dateFormat(fromTemplate: "dd MM", options: 0, locale: locale)
        dateLocaleFormatter = dateLocaleFormatter?.replacingOccurrences(of: "/", with: ".")
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateLocaleFormatter
        return dateFormatter
    }

    static var dayMonthYear: DateFormatter {
        let langCode: String = Locale.current.languageCode ?? ""
        let regCode: String = Locale.current.regionCode ?? ""
        let localCode: String = langCode + "_" + regCode
        let locale = Locale(identifier: localCode)

        var dateLocaleFormatter = DateFormatter.dateFormat(fromTemplate: "dd MM yyyy", options: 0, locale: locale)
        dateLocaleFormatter = dateLocaleFormatter?.replacingOccurrences(of: "/", with: ".")
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateLocaleFormatter

        return dateFormatter
    }

    static var timeFromString: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}
