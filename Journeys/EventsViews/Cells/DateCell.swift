//
//  DateCell.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 25.03.2023.
//

import Foundation
import UIKit
import FSCalendar

final class DateCell: UICollectionViewCell {
    struct DisplayData {
        let startDate: Date?
        let finishDate: Date?
    }
    
    // MARK: - Private Properties
    private var calendar: FSCalendar!
    
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    
    var delegate: DateCellDeledate?
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        backgroundColor =  UIColor(asset: Asset.Colors.Background.brightColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
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
    
    func counfigure(displayData: DisplayData, delegate: DateCellDeledate) {
        setupViews()
        self.delegate = delegate
        guard let arrivalDate = displayData.startDate,
              let departureDate = displayData.finishDate else { return }
        datesRange = datesRange(from: arrivalDate, to: departureDate)
        selectDates(from: displayData.startDate, to: displayData.finishDate)
    }
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension DateCell: FSCalendarDataSource, FSCalendarDelegateAppearance {
}

extension DateCell: FSCalendarDelegate {
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

protocol DateCellDeledate: AnyObject {
    func selectedDateRange(range: [Date])
}
