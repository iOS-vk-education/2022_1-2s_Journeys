//
//  DateFormatter.swift
//  DrPillman
//
//  Created by Сергей Адольевич on 20.07.2022.
//

import Foundation

extension DateFormatter {
    
    static var dayAndWeekDay: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "E dd"
        return dateFormatter
    }
    
    static var fullDateWithDash: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

    static var timeFromString: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}
