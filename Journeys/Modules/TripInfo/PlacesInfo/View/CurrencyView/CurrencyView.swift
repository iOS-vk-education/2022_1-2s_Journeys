//
//  CurrencyView.swift
//  Journeys
//
//  Created by Сергей Адольевич on 01.04.2023.
//

import Foundation
import UIKit
import SnapKit

protocol CurrencyViewDelegate: AnyObject {
}

final class CurrencyView: UIView {
    
    // MARK: Public Properties
    
    weak var delegate: CurrencyViewDelegate?
    
    // MARK: Private Properties
    
    private let currentCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
        return label
    }()
    private let currentCurrencyTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.font = .systemFont(ofSize: 15, weight: .light)
        return textField
    }()
    
    private lazy var localCurrencyLabel: UILabel = currentCurrencyLabel
    private lazy var localCurrencyTextField: UITextField = currentCurrencyTextField
    
    private let arrowsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.left.arrow.right").font(.title.weight(.light))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        setupSubviews()
        makeConstraints()
    }
    
    func setupSubviews() {
        addSubview(currentCurrencyLabel)
        addSubview(localCurrencyLabel)
        addSubview(arrowsImageView)
        addSubview(currentCurrencyTextField)
        addSubview(localCurrencyTextField)
        
        currentCurrencyLabel.text = "Текущая валюта"
        localCurrencyLabel.text = "Местная валюта"
        currentCurrencyLabel.text = "1.0"
    }
    
    func makeConstraints() {
        currentCurrencyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(currentCurrencyTextField.snp.centerX)
            make.top.equalTo(snp.top)
            make.width.lessThanOrEqualTo(currentCurrencyTextField.snp.width)
        }
        currentCurrencyTextField.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.top.equalTo(currentCurrencyLabel.snp.bottom).offset(5)
            make.bottom.equalTo(snp.bottom)
            make.width.equalTo(136)
        }
        
        arrowsImageView.snp.makeConstraints { make in
            make.leading.equalTo(currentCurrencyTextField.snp.trailing).offset(8)
            make.centerY.equalTo(currentCurrencyTextField.snp.centerY)
            make.height.equalTo(22)
            make.width.equalTo(18)
        }
        
        localCurrencyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(localCurrencyTextField.snp.centerX)
            make.top.equalTo(snp.top)
            make.width.lessThanOrEqualTo(localCurrencyTextField.snp.width)
        }
        localCurrencyTextField.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing)
            make.leading.equalTo(arrowsImageView.snp.trailing).offset(8)
            make.top.equalTo(localCurrencyLabel.snp.bottom).offset(5)
            make.bottom.equalTo(snp.bottom)
            make.width.equalTo(136)
        }
    }
}
