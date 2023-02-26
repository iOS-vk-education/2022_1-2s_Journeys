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
    
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    
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
        
        calendar.appearance.headerTitleColor = UIColor(asset: Asset.Colors.Calendar.header)
        calendar.appearance.weekdayTextColor = UIColor(asset: Asset.Colors.Calendar.header)
        calendar.appearance.titleDefaultColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        calendar.firstWeekday = 2
    }
    
    func getDates() -> [Date]? {
        return datesRange
    }
    
    func counfigure(displayData: DisplayData, delegate: CalendarCellDeledate) {
        setupViews()
        self.delegate = delegate
        guard let arrivalDate = displayData.arrivalDate,
              let departureDate = displayData.departureDate else { return }
        datesRange = datesRange(from: arrivalDate, to: departureDate)
        selectDates(from: displayData.arrivalDate, to: displayData.departureDate)
    }
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension CalendarCell: FSCalendarDataSource, FSCalendarDelegateAppearance {
}

extension CalendarCell: FSCalendarDelegate {
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
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]

            return
        }

        if firstDate != nil && lastDate == nil {
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
