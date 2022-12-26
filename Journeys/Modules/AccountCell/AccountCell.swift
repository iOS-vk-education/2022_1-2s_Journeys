//
//  AccountCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation
import UIKit


final class AccountCell: UICollectionViewCell {
    struct Displaydata {
        let text: String?
        let placeHolder: String
        let keyboardType: UIKeyboardType
        let secure: Bool
    }
    
    enum CellType {
        case login
        case password
    }
    
    // MARK: Private properties

    private let textField = UITextField()

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        setupSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        textField.placeholder = nil
        setupSubviews()
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
        contentView.addSubview(textField)
        
        textField.autocorrectionType = .no
        textField.delegate = self

        setupColors()
        makeConstraints()
    }

    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
    }

    private func makeConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func getTextFieldValue() -> String? {
        if textField.text?.count == 0 {
            return nil
        }
        return textField.text
    }
    
    func configure(data: Displaydata) {
        textField.text = data.text
        textField.placeholder = data.placeHolder
        textField.keyboardType = data.keyboardType
        if data.secure {
            textField.textContentType = .oneTimeCode
            textField.isSecureTextEntry = true
        }
    }
}

extension AccountCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
