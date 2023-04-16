//
//  CurrencyView.swift
//  Journeys
//
//  Created by Сергей Адольевич on 11.04.2023.
//

import Foundation
import UIKit

protocol CurrencyViewDelegate: AnyObject {
    func didFinishEditingTextField(text: String, viewType: CurrencyView.ViewType)
}

final class CurrencyView: UIView {
    
    enum ViewType {
        case currentCurrency
        case localCurrency
    }
    
    struct DisplayData {
        let title: String
        let currencyAmount: String
        let currencyName: String
    }
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(asset: Asset.Colors.PlacesInfo.currencyTextFieldBorder)?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
        
        return label
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.font = .systemFont(ofSize: 17, weight: .light)
        textField.keyboardType = .decimalPad
        
        textField.borderStyle = .none
        return textField
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        return label
    }()
    
    private weak var delegate: CurrencyViewDelegate?
    private var viewType: ViewType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func prepareForReuse() {
        title.text = nil
        nameLabel.text = nil
        textField.text = nil
        textField.placeholder = nil
        self.delegate = nil
    }
    
    func setTextFieldValue(to text: String){
        textField.text = text
    }
    
    func configure(data: DisplayData, delegate: CurrencyViewDelegate, viewType: ViewType) {
        title.text = data.title
        nameLabel.text = data.currencyName
        textField.placeholder = data.currencyAmount
        self.delegate = delegate
        self.viewType = viewType
        
        textField.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview().inset(nameLabel.bounds.width + 4)
        }
    }
    
    private func setupView() {
        setupSubViews()
    }
    
    private func setupSubViews() {
        addSubview(title)
        addSubview(backgroundView)
        backgroundView.addSubview(textField)
        backgroundView.addSubview(nameLabel)
        
        textField.addTarget(self, action: #selector(didFinishEditingTextField), for: .editingChanged)
        textField.delegate = self
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(32)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().inset(48)
        }

        nameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func didFinishEditingTextField() {
        guard let viewType, let text = textField.text else { return }
        delegate?.didFinishEditingTextField(text: text, viewType: viewType)
    }
}

extension CurrencyView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.letters) == nil
    }
}
