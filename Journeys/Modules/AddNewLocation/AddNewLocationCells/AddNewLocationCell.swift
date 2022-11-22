//
//  AddNewLocationCell.swift
//  DrPillman
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit


// MARK: - AddNewLocationCell

final class AddNewLocationCell: UITableViewCell, UITextFieldDelegate {
    struct DisplayData {
        let locationString: String?
    }

    // MARK: - Private Properties

    private let locationTextField = UITextField()
    private let chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        return button
    }()
    private let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        backgroundColor =  UIColor(asset: Asset.Colors.Background.brightColor)
        setupViews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        locationTextField.text = ""
        icon.image = nil
    }

    // MARK: Private methods

    private func setupViews() {
        contentView.addSubview(locationTextField)
        contentView.addSubview(chevronButton)
        contentView.addSubview(icon)
        
        locationTextField.delegate = self

        chevronButton.addTarget(self, action: #selector(chevronButtonWasTapped), for: .touchUpInside)
        chevronButton.imageView?.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor) ?? .black
        icon.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor) ?? .black
        locationTextField.placeholder = L10n.arrivalTown
        setupConstraints()
    }

    private func setupConstraints() {
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.Icon.leadingIndent)
            make.centerY.equalToSuperview()
        }
        
        locationTextField.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing)
                .offset(Constants.LocationTextField.leadingIndentFromIcon)
            make.trailing.lessThanOrEqualToSuperview()
                .inset(Constants.LocationTextField.minTraillingIndent)
            make.centerY.equalTo(icon.snp.centerY)
        }

        chevronButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
                .inset(Constants.Chevron.trailingIndent)
            make.centerY.equalTo(icon.snp.centerY)
            make.height.equalTo(Constants.Chevron.height)
            make.width.equalTo(Constants.Chevron.width)
        }
    }
    
    @objc
    private func chevronButtonWasTapped() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: Public methods

    func configure(displayData: DisplayData) {
        if let location = displayData.locationString {
            locationTextField.text = location
        }
    }
}

private extension AddNewLocationCell {
    private enum Constants {
        enum Icon {
            static let leadingIndent: CGFloat = 20
        }

        enum Chevron {
            static let height: CGFloat = 9
            static let width: CGFloat = 19
            static let trailingIndent: CGFloat = 20
        }
        
        enum LocationTextField {
            static let leadingIndentFromIcon: CGFloat = 12
            static let minTraillingIndent: CGFloat = 40
        }
    }
}

