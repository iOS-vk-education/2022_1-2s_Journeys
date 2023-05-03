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
    func didTapCurrencyNameButton(touch: UITapGestureRecognizer,
                                  currentCurrency: String,
                                  viewType: CurrencyView.ViewType)
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
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
        
        return label
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(asset: Asset.Colors.PlacesInfo.currencyTextFieldBorder)?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.addSubview(textField)
        view.addSubview(currencyNameLabel)
        return view
    }()

    private lazy var textField: CurrencyTextField = {
        let textField = CurrencyTextField()
        textField.autocorrectionType = .no
        textField.font = .systemFont(ofSize: 17, weight: .light)
        textField.keyboardType = .decimalPad
        
        textField.borderStyle = .none
        
        textField.addTarget(self, action: #selector(didFinishEditingTextField), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(didTapCurrencyNameLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapRecognizer)
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.setNewTouchableArea(CGRect(x: textField.frame.origin.x - backgroundView.frame.origin.x,
                                             y: textField.frame.origin.y - backgroundView.frame.origin.y,
                                             width: backgroundView.frame.width - currencyNameLabel.frame.width - 8,
                                             height: backgroundView.frame.height))
    }
    
    func prepareForReuse() {
        title.text = nil
        currencyNameLabel.text = nil
        textField.text = nil
        textField.placeholder = nil
        self.delegate = nil
    }
    
    func textFieldValue() -> String? {
        if textField.text?.count == 0 { return nil }
        return textField.text
    }
    
    func setTextFieldValue(to text: String) {
        textField.text = text
    }
    
    func configure(data: DisplayData, delegate: CurrencyViewDelegate, viewType: ViewType) {
        title.text = data.title
        currencyNameLabel.text = data.currencyName
        textField.placeholder = data.currencyAmount
        self.delegate = delegate
        self.viewType = viewType
    }
    
    private func setupView() {
        setupSubViews()
    }
    
    private func setupSubViews() {
        addSubview(title)
        addSubview(backgroundView)
        
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

        currencyNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc
    private func didFinishEditingTextField() {
        guard let viewType, let text = textField.text else { return }
        delegate?.didFinishEditingTextField(text: text, viewType: viewType)
    }
    
    @objc
    private func didTapCurrencyNameLabel(touch: UITapGestureRecognizer) {
        guard let viewType,
              let currentCurrency = currencyNameLabel.text
        else { return }
        delegate?.didTapCurrencyNameButton(touch: touch, currentCurrency: currentCurrency, viewType: viewType)
    }
}

extension CurrencyView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.letters) == nil
    }
}


final class CurrencyTextField: UITextField {
    private(set) lazy var touchableAreaRect = CGRect(x: frame.origin.x,
                                                     y: frame.origin.y ,
                                                     width: frame.width,
                                                     height: frame.height)
    
    func setNewTouchableArea(_ rect: CGRect) {
        touchableAreaRect = rect
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        touchableAreaRect.contains(point)
    }
}
