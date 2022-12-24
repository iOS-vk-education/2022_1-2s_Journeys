//
//  CalendarCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 22.11.2022.
//

import Foundation
import UIKit
import FSCalendar

final class CalendarCell: UITableViewCell {
    struct DisplayData {
        let arrivalDate: Date?
        let departureDate: Date?
    }
    
    // MARK: - Private Properties
    private var calendar: FSCalendar!
    
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    var datesRange: [Date]?
    
    var delegate: CalendarCellDeledate?
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        backgroundColor =  UIColor(asset: Asset.Colors.Background.brightColor)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupViews() {
        let calendarFrame = CGRect(x: contentView.frame.minX + 10,
                                   y: contentView.frame.minY + 10,
                                   width: contentView.frame.size.width - 20,
                                   height: contentView.frame.size.height - 20)
        calendar = FSCalendar(frame: calendarFrame)
        contentView.addSubview(calendar)
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.allowsMultipleSelection = true
        
    }
    
    func counfigure(displayData: DisplayData, delegate: CalendarCellDeledate) {
        setupViews()
        self.delegate = delegate
        selectDates(from: displayData.arrivalDate, to: displayData.departureDate)
    }
    
}

extension CalendarCell: FSCalendarDataSource {
    
}

extension CalendarCell: FSCalendarDelegate {
//    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        performDateDeselect(calendar, date: date)
//        return true
//    }
//
//
//    private func performDateDeselect(_ calendar: FSCalendar, date: Date) {
//        let sorted = calendar.selectedDates.sorted { $0 < $1 }
//        if let index = sorted.firstIndex(of: date)  {
//            let deselectDates = Array(sorted[index...])
//            calendar.deselectDates(deselectDates)
//        }
//    }
//
//    private func performDateSelection(_ calendar: FSCalendar) {
//        let sorted = calendar.selectedDates.sorted { $0 < $1 }
//        if let firstDate = sorted.first, let lastDate = sorted.last {
//            let ranges = datesRange(from: firstDate, to: lastDate)
//            calendar.selectDates(ranges)
//        }
//    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }

    func selectDates(from arrivalDate: Date?, to departureDate: Date?) {
        if arrivalDate != nil && departureDate != nil {
            firstDate = arrivalDate
            lastDate = departureDate
            let range = datesRange(from: arrivalDate!, to: departureDate!)
            for day in range {
                calendar.select(day, scrollToDate: true)
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]

            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for day in range {
                calendar.select(day)
            }

            datesRange = range
            delegate?.selectedDateRange(range: range)
            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for day in calendar.selectedDates {
                calendar.deselect(day)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:

        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for day in calendar.selectedDates {
                calendar.deselect(day)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
        }
    }
}

protocol CalendarCellDeledate: AnyObject {
    func selectedDateRange(range: [Date])
}
