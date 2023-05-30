//
//  Calendar.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.05.2023.
//

import Foundation

extension Calendar {
    static func daysBetween(start: Date, end: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: start, to: end).day
    }
}
