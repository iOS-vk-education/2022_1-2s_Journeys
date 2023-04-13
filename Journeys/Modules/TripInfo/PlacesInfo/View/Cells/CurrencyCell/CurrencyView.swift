////
////  CurrencyView.swift
////  Journeys
////
////  Created by Сергей Адольевич on 11.04.2023.
////
//
//import Foundation
//import UIKit
//
//final class CurrencyView: UIView {
//    
//    private let background: UIView = {
//        let view = UIView()
//        view.layer.borderColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
//        view.layer.borderWidth = 1
//        return view
//    }
//    private lazy var title: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13, weight: .light)
//        label.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
//        
//        label.text = "Местная валюта"
//        return label
//    }()
//    private lazy var textField: UITextField = {
//        let textField = UITextField()
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.font = .systemFont(ofSize: 15, weight: .light)
//        textField.keyboardType = .decimalPad
//        
//        textField.borderStyle = UITextField.BorderStyle.roundedRect
//        return textField
//    }()
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13)
//        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
//        return label
//    }()
//}
