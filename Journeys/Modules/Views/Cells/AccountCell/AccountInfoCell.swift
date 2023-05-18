//
//  AccountInfoCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.12.2022.
//

import Foundation
import UIKit


final class AccountInfoCell: UITableViewCell {
    struct DisplayData {
        let text: String?
        let placeHolder: String
        let keyboardType: UIKeyboardType
        let secure: Bool
    }
    
    enum CellType {
        enum PersonalInfo: CaseIterable {
            case firstName
            case lastName
            
            var placeholder: String {
                switch self {
                case .firstName: return  L10n.firstName
                case .lastName: return L10n.lastName
                default: return ""
                }
            }
        }
        enum LoginInfo: CaseIterable {
            case email
            case pasword
            case newPassword
            case confirmPassword
            
            var placeholder: String {
                switch self {
                case .email: return  L10n.email
                case .pasword: return L10n.password
                case .newPassword: return L10n.newPassword
                case .confirmPassword: return L10n.confirmPassword
                default: return ""
                }
            }
        }
    }
    
    // MARK: Private properties

    private let textField = UITextField()
    
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        setupSubviews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        textField.placeholder = nil
        textField.isSecureTextEntry = false
        setupSubviews()
    }

    // MARK: Private functions
    
    private func setupSubviews() {
        contentView.addSubview(textField)
        
        textField.autocapitalizationType = .none
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
    
    func clearTextField() {
        textField.text = nil
    }
    
    func getTextFieldValue() -> String? {
        if textField.text?.count == 0 {
            return nil
        }
        return textField.text
    }
    
    func configure(data: DisplayData) {
        textField.text = data.text
        textField.placeholder = data.placeHolder
        textField.keyboardType = data.keyboardType
        if data.secure {
            textField.textContentType = .oneTimeCode
            textField.isSecureTextEntry = true
        }
    }
}

extension AccountInfoCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
