////
////  Calendar.swift
////  Journeys
////
////  Created by Сергей Адольевич on 26.05.2023.
////
//
//import Foundation
//
//extension Calendar {
//    func numberOfDaysBetween(from: Date, to: Date) -> Int? {
//        let fromDate = startOfDay(for: from)
//        let toDate = startOfDay(for: to)
//        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
//        
//        guard let daysCount = numberOfDays.day else {
//            return nil
//        }
//        return daysCount + 1
//    }
//}
