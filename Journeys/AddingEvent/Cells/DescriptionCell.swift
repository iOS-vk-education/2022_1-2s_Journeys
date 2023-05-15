//
//  DescriptionCell.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 25.03.2023.
//

import Foundation
import UIKit
import PureLayout

struct DescriptionCellDisplayData {
    let text : String
}

final class DescriptionCell: UICollectionViewCell {
    private let inputField: UITextView = {
        var inpField = UITextView()
        inpField.text = ""
        inpField.font = UIFont.systemFont(ofSize: DescriptionCellConstants.InputField.fontSize)
        inpField.layer.borderWidth = DescriptionCellConstants.Cell.shadowRadius
        inpField.layer.borderColor = UIColor(asset: Asset.Colors.SpecifyAdress.photoButton)?.cgColor
        inpField.layer.cornerRadius = DescriptionCellConstants.Cell.borderRadius
        inpField.clipsToBounds = true
        return inpField
    }()
    private let descriptionLabel: UILabel = {
        let inpField = UILabel()
        inpField.text = L10n.descriptionOfTheEvent
        return inpField
    }()
    private var delegate: DescriptionCellDelegate!
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
        inputField.text = ""
        setupSubviews()
}
    // MARK: Private functions
    private func setupCell() {
        layer.cornerRadius = DescriptionCellConstants.Cell.borderRadius
        layer.masksToBounds = false
        layer.shadowRadius = DescriptionCellConstants.Cell.shadowRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Float(DescriptionCellConstants.Cell.shadowOpacity)
        layer.shadowOffset = CGSize(width: 0, height: DescriptionCellConstants.Cell.shadowOffset)
    }
    private func setupSubviews() {
        contentView.addSubview(inputField)
        contentView.addSubview(descriptionLabel)
        setupColors()
        makeConstraints()
        setupFonts()
    }
    private func setupColors() {
        backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        inputField.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
    }
    private func setupFonts() {
        descriptionLabel.font = UIFont.systemFont(ofSize: DescriptionCellConstants.Cell.fontSize, weight: .bold)
    }
    private func makeConstraints() {
        inputField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(DescriptionCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(DescriptionCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(50)
            make.bottom.equalToSuperview().inset(DescriptionCellConstants.InputField.verticalIndent)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(DescriptionCellConstants.InputField.horisontalIndent)
            make.trailing.equalToSuperview().inset(DescriptionCellConstants.InputField.horisontalIndent)
            make.top.equalToSuperview().inset(DescriptionCellConstants.horisontalIndentForAllSubviews)

        }
    }
    func configure(delegate: DescriptionCellDelegate) {
        self.delegate = delegate
    }
    func returnText() -> String {
        return inputField.text!
    }
}
    private extension DescriptionCell {
        struct DescriptionCellConstants {
            static let horisontalIndentForAllSubviews: CGFloat = 16.0
            struct InputField {
                static let horisontalIndent: CGFloat = horisontalIndentForAllSubviews
                static let verticalIndent: CGFloat = 16
                static let cornerRadius: CGFloat = 15.0
                static let fontSize : CGFloat = 17
            }
            struct Cell {
                static let borderRadius: CGFloat = 10.0
                static let shadowRadius: CGFloat = 3
                static let shadowOpacity: CGFloat = 0.1
                static let shadowOffset = 2
                static let fontSize : CGFloat = 22
            }
        }
}

protocol DescriptionCellDelegate: AnyObject {
    func editingBegan()
}
