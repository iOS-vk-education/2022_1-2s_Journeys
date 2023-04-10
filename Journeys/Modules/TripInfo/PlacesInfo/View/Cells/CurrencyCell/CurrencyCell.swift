//
//  CurrencyCell.swift
//  Journeys
//
//  Created by Сергей Адольевич on 01.04.2023.
//

import Foundation
import UIKit
import SnapKit

protocol CurrencyViewDelegate: AnyObject {
}

final class CurrencyCell: UICollectionViewCell {
    
    struct DisplayData {
        let title: String
        let course: Decimal
        let currentCurrencyName: String
        let localCurrencyName: String
    }
    
    // MARK: Public Properties
    
    weak var delegate: CurrencyViewDelegate?
    let identifier: String = "CurrencyCell"
    
    // MARK: Private Properties
    
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let currentCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
        label.text = "Текущая валюта"
        return label
    }()
    private let currentCurrencyTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.font = .systemFont(ofSize: 15, weight: .light)
        
        textField.text = "1.0"
        return textField
    }()
    private let currentCurrencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        return label
    }()
    
    
    private lazy var localCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor(asset: Asset.Colors.Text.secondaryTextColor)
        
        label.text = "Местная валюта"
        return label
    }()
    
    private lazy var localCurrencyTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.font = .systemFont(ofSize: 15, weight: .light)
        
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()
    private let localCurrencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        return label
    }()
    
    
    private let arrowsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.left.arrow.right",
                                  withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        imageView.tintColor = UIColor(asset: Asset.Colors.BaseColors.contrastToThemeColor)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var course: Decimal?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        currentCurrencyTextField.text = nil
        currentCurrencyLabel.text = nil
        localCurrencyTextField.text = nil
        localCurrencyLabel.text = nil
    }
    
    func configure(displayData: DisplayData) {
        self.title.text = displayData.title
        self.course = displayData.course
        
        self.currentCurrencyNameLabel.text = displayData.currentCurrencyName
        self.localCurrencyNameLabel.text = displayData.currentCurrencyName
    }
    
    private func setupView() {
        setupSubviews()
        makeConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(title)
        contentView.addSubview(currentCurrencyLabel)
        contentView.addSubview(localCurrencyLabel)
        contentView.addSubview(arrowsImageView)
        contentView.addSubview(currentCurrencyTextField)
        currentCurrencyTextField.addSubview(currentCurrencyNameLabel)
        contentView.addSubview(localCurrencyTextField)
        localCurrencyTextField.addSubview(localCurrencyNameLabel)
        
        currentCurrencyLabel.textAlignment = .center
        localCurrencyLabel.textAlignment = .center
    }
    
    private func makeConstraints() {
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        currentCurrencyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(currentCurrencyTextField.snp.centerX)
            make.top.equalTo(title.snp.bottom).offset(17)
        }
        currentCurrencyTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(currentCurrencyLabel.snp.bottom).offset(5)
            make.height.equalTo(28)
            make.width.equalTo(136)
        }
        currentCurrencyNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(9)
            make.centerY.equalToSuperview()
        }

        arrowsImageView.snp.makeConstraints { make in
            make.leading.equalTo(currentCurrencyTextField.snp.trailing).offset(8)
            make.centerY.equalTo(currentCurrencyTextField.snp.centerY)
            make.height.equalTo(22)
            make.width.equalTo(18)
        }

        localCurrencyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(localCurrencyTextField.snp.centerX)
            make.top.equalTo(currentCurrencyLabel.snp.top)
        }
        localCurrencyTextField.snp.makeConstraints { make in
            make.leading.equalTo(arrowsImageView.snp.trailing).offset(8)
            make.top.equalTo(localCurrencyLabel.snp.bottom).offset(5)
            make.height.equalTo(28)
            make.width.equalTo(136)
            make.trailing.equalToSuperview()
        }
        localCurrencyNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(9)
            make.centerY.equalToSuperview()
        }
    }
}
