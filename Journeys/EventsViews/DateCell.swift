//
//  ViewController.swift
//  journeys.1
//
//  Created by User on 04.12.2022.
//

import Foundation
import UIKit
import SnapKit
import PureLayout


final class DateCell: UICollectionViewCell {
    
    
    private var delegate: DateCellDelegate!
    private var date : String!
    private var dataPicker : UIDatePicker{
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        return picker
    }
    
    private var toolbar: UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        return toolbar
    }
    
    func getDateFromPicker() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyy HH:mm"
        date = formatter.string(from: dataPicker.date)
        return date
        
    }
    
    func addTargetforDatePicker() {
        dataPicker.addTarget(self, action: #selector(didDataChange), for: .allEditingEvents)
    }
    @objc func didDataChange() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyy HH:mm"
        date = formatter.string(from: dataPicker.date)
        print(date)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        setupSubviews()
        setupConstraints()
        addTargetforDatePicker()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupSubviews()
        setupConstraints()
        addTargetforDatePicker()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupSubviews()
        setupConstraints()
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
    }
    
    private func setupDataPicker() {
            contentView.addSubview(toolbar)
            contentView.addSubview(dataPicker)
    }
    
    
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(DateCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(DateCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(DateCellConstants.InputField.verticalIndent)
            make.bottom.equalToSuperview().inset(DateCellConstants.InputField.verticalIndent)
            
        }

    }
    
    @objc func editingBegan(_ searchBar: UITextField) {
        
    }
    
}
    
    private extension DateCell {
        
        struct DateCellConstants {
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

protocol DateCellDelegate: AnyObject {
    func editingBegan()
}

