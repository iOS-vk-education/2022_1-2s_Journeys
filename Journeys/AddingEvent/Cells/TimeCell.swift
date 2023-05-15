//
//  ViewController.swift
//  journeys.1
//
//  Created by User on 04.12.2022.
//

import Foundation
import UIKit
import PureLayout

struct TimeCellDisplayData {
    let text : String
}

final class TimeCell: UICollectionViewCell {
    private var delegate: TimeCellDelegate!
    private var date : String!
    var time : Date = .now
    private let datePicker = UIDatePicker()
    private let inputField: UILabel = {
        let inpField = UILabel()
        inpField.font = .boldSystemFont(ofSize: 17)
        return inpField
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        datePicker.datePickerMode = .dateAndTime
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        setupCell()
        setupSubviews()
        setupConstraints()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        setupCell()
        setupSubviews()
        setupConstraints()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        setupSubviews()
        setupConstraints()
    }
    func getDateFromPicker() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        date = formatter.string(from: datePicker.date)
        print(datePicker.date)
        
        return datePicker.date
    }
    @objc
    func dateChanged() -> Date {
        time = getDateFromPicker()
        return time
    }
    // MARK: Private functions
    private func setupCell() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    private func setupSubviews() {
        setupColors()
        setupDataPicker()
        contentView.addSubview(inputField)
    }
    private func setupDataPicker() {
            contentView.addSubview(datePicker)
    }
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }
    private func setupConstraints() {
        datePicker.autoAlignAxis(toSuperviewAxis: .horizontal)
        datePicker.autoPinEdge(toSuperviewSafeArea: .right, withInset: TimeCellConstants.horisontalIndentForAllSubviews)
        inputField.autoAlignAxis(toSuperviewAxis: .horizontal)
        inputField.autoPinEdge(toSuperviewSafeArea: .left, withInset: TimeCellConstants.horisontalIndentForAllSubviews)
    }
    func configure(data: TimeCellDisplayData) {
        inputField.text = data.text
    }
}
    private extension TimeCell {
        struct TimeCellConstants {
            static let horisontalIndentForAllSubviews: CGFloat = 16.0
            struct InputField {
                static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
                static let verticalIndent: CGFloat = 16
                static let cornerRadius: CGFloat = 15.0
            }
            struct Cell {
                static let borderRadius: CGFloat = 10.0
            }
        }
}

protocol TimeCellDelegate: AnyObject {
    func editingBegan()
}
